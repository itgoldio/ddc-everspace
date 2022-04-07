pragma ton-solidity = 0.58.1;

import '../libraries/Roles.sol';

interface IAccount {
    function get() external view responsible returns(uint256 did, address owner, uint8 role, address factory, string name);
}