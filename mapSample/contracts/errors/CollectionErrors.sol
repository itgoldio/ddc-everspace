pragma ton-solidity >= 0.43.0;

/**
    Reserved codes - 100-199
 */
library CollectionErrors {
    uint8 constant pubkey_is_empty = 100;
    uint8 constant not_my_pubkey = 101;
    uint8 constant value_less_than_required = 102;
    uint8 constant index_not_deployed = 103;
    uint8 constant value_is_greater_than_the_balance = 104;
    uint8 constant value_is_empty = 105;
    uint8 constant sender_in_not_data = 106;
    uint8 constant nft_is_not_exists = 107;
    uint8 constant owner_is_not_exists = 108;
}
