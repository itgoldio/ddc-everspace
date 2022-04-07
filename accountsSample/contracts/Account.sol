pragma ton-solidity = 0.58.1;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import './libraries/Roles.sol';
import './Interfaces/IAccount.sol';
import './Interfaces/IAccountFactory.sol';


contract Account is IAccount {

    uint256 static _did;
    address static _owner;
    uint8 _role;
    address _factory;
    string _name;
    TvmCell _codeAccount;

    constructor(string name, TvmCell codeAccount) public {
        
        optional(TvmCell) optSalt = tvm.codeSalt(tvm.code());
        require(optSalt.hasValue(), 50);
        (address factory,uint8 role) = optSalt.get().toSlice().decode(address, uint8);
        require(msg.sender == factory, 51);
        tvm.accept();

        _role = role;
        _factory = factory;
        _name = name;
        _codeAccount = codeAccount;
    }

    function get() external view virtual override responsible returns(
        uint256 did,
        address owner,
        uint8 role,
        address factory,
        string name)
    {
        return {value: 0, flag: 64, bounce: false} (
            _did,
            _owner,
            _role,
            _factory,
            _name
        );
    }

    function proxingTransaction(address dest, bool bounce, TvmCell payload) public view onlyOwner
    {
        tvm.rawReserve(0, 4);
        dest.transfer(0, bounce, 128, payload);
    }

    function createAccountConsumer(string name, address accountOwner) public view onlyOwner {
        require(_role==Roles.Operator || _role == Roles.PlatformManager);
        tvm.rawReserve(0, 4);

        IAccountFactory(_factory).createAccountConsumer{value:0, flag: 128}(_did, name, msg.sender, accountOwner);
    }

    function createAccountPlatformManager(string name, address accountOwner) public view onlyOwner {
        require(_role == Roles.Operator);
        tvm.rawReserve(0, 4);

        IAccountFactory(_factory).createAccountPlatformManager{value:0, flag: 128}(_did, name, msg.sender, accountOwner);
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender) == true);
        _;
    }

    function isOwner(address sender) private view returns (bool){
        return sender == _owner;
    }
}

