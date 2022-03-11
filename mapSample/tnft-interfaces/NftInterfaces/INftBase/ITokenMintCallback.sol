pragma ton-solidity = 0.47.0;
pragma AbiHeader expire;

interface ITokenMintCallback {
    function tokenMintCallback(
        uint256 id,
        address ownerAddr,
        address sendGasToAddr
    ) external;
}