## What is needed for development?

- Install [TON Solidity Compiler](https://github.com/tonlabs/TON-Solidity-Compiler.git)
- Install [TVM linker](https://github.com/tonlabs/TVM-linker/releases/tag/0.14.2)
- Install [nmp](https://www.npmjs.com/)
- Install  [TON locklift](https://github.com/broxus/ton-locklift)
- Install [tonos-cli](https://github.com/tonlabs/tonos-cli)

## Build demo

1. Get [testnet](https://net.ever.live/) coins
1. Deploy your [giver](https://github.com/broxus/ton-contracts/tree/master/contracts/giver) to testnet
1. Change [locklift.config.js](locklift.config.js)
   1. update paths for ``compiler``, ``linker`` 
   1. Set ``giver`` address and keys
   1. generate key by ``tonos-cli`` for keys section
1. build and deploy
   1. build ``locklift build --config locklift.config.js`` 
   1. deploy ``locklift run --config locklift.config.js --network devnet --script scripts/1-deploy.js``


## Description

Every [Account](contracts/Account.sol) is unique smart contract. They are deployed from [AccountFactory](contracts/AccountFactory.sol).


``Operator`` deploy one ``AccountFactory`` contract.

``AccountFactory`` deploy ``Account`` contracts with Roles

``Account`` contract address use ``DID`` and address Consumer\Operator\PlatformManager when generated

``Account`` contract code salted ``AccountFactory`` address by security reason.

``Account`` contract code salted ``RoleID`` to simplify the search accounts.

``Account`` controlled use internal messages from wallets [safemultisig](https://github.com/tonlabs/ton-labs-contracts/tree/master/solidity/safemultisig), [setcodemultisig](https://github.com/tonlabs/ton-labs-contracts/tree/master/solidity/setcodemultisig), [surf](https://github.com/tonlabs/ton-labs-contracts/tree/multisig-surf-v2/solidity/surfmultisig)


## Sample

AccountFactory address: ``0:79aa4ae6b52a21263edebf5fc9b6e6f1616c05e37f00a3399caa408621ad1051``

### Create DID and operator

Create operator call ``AccountFactory.createAccountOperator``
- DID=``001``
- operator Name = ``TestOp1``
- addr owner = ``0:a1034145a3b7a3c6ffb06e127eaadf60b820527560c0a6eb97502b48c347ca78``

Succsessed by addr ``0:f3c2b37fca4df940f0f6b1095542fca9f682640bb2b0ef9c2b50985d60249291``

### Create platform manager for DID=001

Send internal message from wallet ``0:a1034145a3b7a3c6ffb06e127eaadf60b820527560c0a6eb97502b48c347ca78`` to account ``0:f3c2b37fca4df940f0f6b1095542fca9f682640bb2b0ef9c2b50985d60249291``. Call ``Account.createAccountPlatformManager``

- Create platform manager Name = ``TestManager1``
- addr owner = ``0:a1034145a3b7a3c6ffb06e127eaadf60b820527560c0a6eb97502b48c347ca78``

Succsessed by addr ``0:ac44a661cf1101c8aba2b6ba0199f2477976d8af56c8280ea05564a4f0cbc3a1``

### Create consumers for DID=001

Send internal message from wallet ``0:a1034145a3b7a3c6ffb06e127eaadf60b820527560c0a6eb97502b48c347ca78`` to account ``0:ac44a661cf1101c8aba2b6ba0199f2477976d8af56c8280ea05564a4f0cbc3a1``. Call ``Account.createAccountConsumer``


- Create consumer1 Name = ``TestConsumer1``
- addr owner = ``0:57799e0e5b16eea560ed4ad603a07da5ddb9a93ea53fda68ad1b4bc9482e8199``

- Create consumer2 Name = ``TestConsumer2``
- addr owner = ``0:57799e0e5b16eea560ed4ad603a07da5ddb9a93ea53fda68ad1b4bc9482e8100``

Succsessed by addrs ``0:252b255f3a3b47207161284b01b9270ff7809866506fd33f744a35b9ca466d3a`` and ``0:938b9ce1e2ae2fb7e8e2466c8bee875e7fa35509841f76f59238c9a1092b82be``

## How to find all consumers

[by codehash](https://net.ever.live/contracts/contractDetails?codeHash=d3cf32c9dc7b57aa6c839d2c31101bc47f772b5134e6ae5020a3f1cc42ce92b3)

## How to find all platform managers

[by codehash](https://net.ever.live/contracts/contractDetails?codeHash=5aac42cb051144777b56f72a1279cdbd9a02be4f37e85541fd26d0b2ed5f2bd0)

## How to find all operators

[by codehash](https://net.ever.live/contracts/contractDetails?codeHash=4dde37050e8f93221ac66cd18b91cede14ce8eb784d98e456ed570e01cc9b05f)

## More info

### We can deploy ``AccountFactory`` by ``DID``
You can move ``DID`` to static field in ``AccountFactory`` and deploy instance ``AccountFactory`` for platform (NFT publishers, companies, Interlecetual property holders, Artsits companies). It will more flexible and faster.

### We can merge ``Account`` code and wallet code
We can use ``Account`` as wallet, but wallet that can be frozen\deleted by platform manager. It will more powerfull option, but can be unsupported current web extensions or wallets

### Platform and operator interact with accounts async
Platform and operator accounts can send command message (freeze, delete and etc) to consumers account directly. It's safely and fast. Only "create account" commands proxying  from ``AccountFactory``

### any quantity platform managerы with same DID
It's true for current solution

### More fileds for Account
You can expand ``Account`` fields as you wish

### Find all accounts (like map AccountList)
You can find all accounts by codehash.
At this time we have different codehash for platform, operator and consumer accounts. It can be easy to change, just don't salted code by ``RoleID``

### Find all DID (like map DIDAccountList)
Not implemented yet. Need to add DID index. It will be added

