pragma ton-solidity = 0.58.1;

import '../libraries/Roles.sol';

interface IAccountFactory {

    event AccountCreated(address account, uint256 did, uint8 role);

    function createAccountConsumer(uint256 did, string name, address sender, address accountOwner) external view;

    function createAccountOperator(uint256 did, string name, address accountOwner) external view;

    function createAccountPlatformManager(uint256 did, string name, address sender, address accountOwner) external view;
}