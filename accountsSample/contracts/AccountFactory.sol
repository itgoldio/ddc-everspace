pragma ton-solidity = 0.58.1;
pragma AbiHeader expire;
pragma AbiHeader pubkey;


import './libraries/Roles.sol';
import './Interfaces/IAccountFactory.sol';
import './Account.sol';

contract AccountFactory is IAccountFactory  {

    uint16 static _nonce;

    TvmCell _codeAccount;
    address _owner;

    constructor(TvmCell codeAccount, address owner) public {
        tvm.accept();

        _codeAccount = codeAccount;
        _owner = owner;
    }



    function createAccountConsumer(uint256 did, string name, address sender, address accountOwner) public override view canCreateConsumer(did, sender) {
        tvm.rawReserve(0, 4);

        createAccount(did, name, accountOwner, Roles.Consumer);
    }

    function createAccountOperator(uint256 did, string name, address accountOwner) public override view canCreateOperator() {
        tvm.rawReserve(0, 4);

        createAccount(did, name, accountOwner, Roles.Operator);
    }

    function createAccountPlatformManager(uint256 did, string name, address sender, address accountOwner) public override view canCreatePlatformManager(did, sender) {
        tvm.rawReserve(0, 4);
        
        createAccount(did, name, accountOwner, Roles.PlatformManager);

    }

    function createAccount(uint256 did, string name, address accountOwner, uint8 role) private view {

        TvmCell codeAccount = _buildAccountCode(role);
        TvmCell stateAccount = _buildAccountState(codeAccount, did, accountOwner);

        address accountAddr = new Account{
               stateInit: stateAccount,
               value: 0,
               flag: 128
            }
            (name, _codeAccount); 

        emit AccountCreated(accountAddr, did, Roles.Consumer);
    }


    modifier canCreateConsumer(uint256 did,  address sender) {
        require((isOperator(did, sender) || isPlatformManager(did, sender)) == true);
        _;
    }

    modifier canCreateOperator() {
        require(msg.sender == _owner);
        _;
    }

    modifier canCreatePlatformManager(uint256 did,  address sender) {
        require(isOperator(did, sender) == true);
        _;
    }



    function isOperator(uint256 did,  address sender) private view returns (bool){
        TvmCell codeAccount = _buildAccountCode(Roles.Operator);
        TvmCell stateAccount = _buildAccountState(codeAccount, did, sender);
        uint256 hashStateAccount = tvm.hash(stateAccount);
        address addressAccount = address.makeAddrStd(0, hashStateAccount);

        return msg.sender == addressAccount;
    }

    function isPlatformManager(uint256 did,  address sender) private view returns (bool){
        TvmCell codeAccount = _buildAccountCode(Roles.PlatformManager);
        TvmCell stateAccount = _buildAccountState(codeAccount, did, sender);
        uint256 hashStateAccount = tvm.hash(stateAccount);
        address addressAccount = address.makeAddrStd(0, hashStateAccount);

        return msg.sender == addressAccount;
    }

    function _buildAccountCode(uint8 role) internal virtual view returns (TvmCell) {
        TvmBuilder salt;
        salt.store(address(this));
        salt.store(role);
        return tvm.setCodeSalt(_codeAccount, salt.toCell());
    }

    function _buildAccountState(TvmCell code, uint256 did, address owner) internal virtual pure returns (TvmCell) {
        return tvm.buildStateInit({
            contr: Account,
            varInit: {
                _did: did,
                _owner : owner
                },
            code: code
        });
    }
    
}

