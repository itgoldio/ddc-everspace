pragma ton-solidity = 0.47.0;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import './resolvers/NftResolver.sol';

import './errors/CollectionErrors.sol';
import '../tnft-interfaces/NftInterfaces/INftBase/ITokenTransferCallback.sol';
import '../tnft-interfaces/NftInterfaces/INftBase/ITokenMintCallback.sol';

contract Collection is NftResolver, ITokenTransferCallback, ITokenMintCallback {

    uint256 _ownerPubkey;
    uint256 _totalMinted;
    string _name;
    string _symbol;

    /// nftId => ownerAddr
    mapping(uint256 => address) public _owners;
    /// ownerAddr => countNft
    mapping(address => uint128) public _balances;

    /// _remainOnNft - the number of crystals that will remain after the entire mint 
    /// process is completed on the Nft contract
    uint128 _remainOnNft = 0.3 ton;

    event TokenWasMinted(address nftAddr, address creatorAddr);

    constructor(
        string name,
        string symbol,
        TvmCell codeNft, 
        uint256 ownerPubkey
    ) public {
        TvmCell empty;
        require(ownerPubkey != 0, CollectionErrors.pubkey_is_empty);
        require(codeNft != empty, CollectionErrors.value_is_empty);
        tvm.accept();

        _name = name;
        _symbol = symbol;
        _codeNft = codeNft;
        _ownerPubkey = ownerPubkey;
    }

    function mintNft(
        string dataName,
        string json
    ) public {
        tvm.rawReserve(msg.value, 1);

        TvmCell codeNft = _buildNftCode(address(this));
        TvmCell stateNft = _buildNftState(codeNft, _totalMinted);
        address nftAddr = new Nft{
            stateInit: stateNft,
            value: _remainOnNft
            }(
                _name,
                _symbol,
                msg.sender,
                json,
                dataName
            ); 

        emit TokenWasMinted(nftAddr, msg.sender);

        _totalMinted++;

        msg.sender.transfer({value: 0, flag: 128});
    }

    function withdraw(address to, uint128 value) public pure onlyOwner {
        require(address(this).balance > value, CollectionErrors.value_is_greater_than_the_balance);
        tvm.accept();
        to.transfer(value, true, 0);
    }

    function tokenMintCallback(
        uint256 id,
        address ownerAddr,
        address sendGasToAddr
    ) public override {
        require(resolveNft(address(this), id) == msg.sender, CollectionErrors.sender_in_not_data);
        tvm.rawReserve(msg.value, 1);

        _owners[id] = ownerAddr;
        if (_balances.exists(ownerAddr)) {
            _balances[ownerAddr] = _balances[ownerAddr] + 1;
        } else {
            _balances[ownerAddr] = 1;
        }

        sendGasToAddr = sendGasToAddr.value == 0 ? msg.sender : sendGasToAddr;
        sendGasToAddr.transfer({value: 0, flag: 128});
    }

    function tokenTransferCallback(
        uint256 id,
        address oldOwner,
        address newOwner,
        address tokenRoot,
        address sendGasToAddr,
        TvmCell payload
    ) public override {
        require(resolveNft(address(this), id) == msg.sender, CollectionErrors.sender_in_not_data);
        require(_owners.exists(id), CollectionErrors.nft_is_not_exists);
        require(_balances.exists(oldOwner), CollectionErrors.owner_is_not_exists);
        tvm.rawReserve(msg.value, 1);

        _owners[id] = newOwner;
        if (_balances[oldOwner] == 1) {
            delete _balances[oldOwner];
        } else {
            _balances[oldOwner] = _balances[oldOwner] - 1;
        }

        if (_balances.exists(newOwner)) {
            _balances[newOwner] = _balances[newOwner] + 1;
        } else {
            _balances[newOwner] = 1;
        }

        sendGasToAddr = sendGasToAddr.value == 0 ? msg.sender : sendGasToAddr;
        sendGasToAddr.transfer({value: 0, flag: 128});
    }

    function setRemainOnNft(uint128 remainOnNft) public onlyOwner {
        tvm.accept();
        _remainOnNft = remainOnNft;
    }   

    function getRemainOnNft() public view returns(uint128) {
        return _remainOnNft;
    }

    function getTotalMinted() public view returns(uint256) {
        return _totalMinted;
    }

    modifier onlyOwner {
        require(msg.pubkey() == _ownerPubkey, CollectionErrors.not_my_pubkey);
        _;
    }

}