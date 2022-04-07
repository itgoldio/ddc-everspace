pragma ton-solidity >= 0.58.0;

library Roles {

    /// NFT publishers, companies, Interlecetual property holders, Artsits companies
    uint8 constant PlatformManager = 0;

    /// BSN, or any company running the infrastructure
    uint8 constant Operator = 1;

    // normal buyers, traders
    uint8 constant Consumer = 2;
}
    