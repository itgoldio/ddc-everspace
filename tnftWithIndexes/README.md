<h1>Queries to the Dapp</h1>

<h2>Get balance by owner addr</h2>
If you want to get the <b>addresses</b> of your nfts, use the following example:

1. Run gettter-method from the NftRoot (resolveCodeHashIndex)
```
tonos-cli run 0:37f7c813a2b66c372afb5a16e707ac82572944dec80fe3ba16b4eae569b71e14 resolveCodeHashIndex '{"addrRoot": "0:37f7c813a2b66c372afb5a16e707ac82572944dec80fe3ba16b4eae569b71e14", "addrOwner": "0:488921925e7f2d103ba1fd0af0552f180ea94ce0df7b6f82eed69d27e7882106"}' --abi NftRoot.abi.json
```

Answer:
```
Running get-method...
Succeeded.
Result: {
  "codeHashIndex": "0x43083893be7eb4c3a23c36baa2237638605c345b33907a61999634bf7f63ce4e"
}
```

2. Go to the dapp with the following query:
```
query { 
    accounts 
    (filter : {
        code_hash :{eq : "43083893be7eb4c3a23c36baa2237638605c345b33907a61999634bf7f63ce4e"}
    })
{
    id
}}
```

Answer:
```
{
  "data": {
    "accounts": [
      {
        "id": "0:9b37ec7e6a52d42b253b814f11788cda261fea64a5a3dc6e303f4b945aba6546"
      },
      {
        "id": "0:db51dcbf9ba6d0001731c6944f57c701df0b6566e199b38b53fdc5e7a320618f"
      }
    ]
  }
}
```

If you want to get the <b>count</b> of your nfts, use the following example:

1. Run gettter-method from the NftRoot (resolveCodeHashIndex)
```
tonos-cli run 0:37f7c813a2b66c372afb5a16e707ac82572944dec80fe3ba16b4eae569b71e14 resolveCodeHashIndex '{"addrRoot": "0:37f7c813a2b66c372afb5a16e707ac82572944dec80fe3ba16b4eae569b71e14", "addrOwner": "0:488921925e7f2d103ba1fd0af0552f180ea94ce0df7b6f82eed69d27e7882106"}' --abi NftRoot.abi.json
```

Answer:
```
Running get-method...
Succeeded.
Result: {
  "codeHashIndex": "0x43083893be7eb4c3a23c36baa2237638605c345b33907a61999634bf7f63ce4e"
}
```

2. Go to the dapp with the following query:
```
query {
  aggregateAccounts(
    filter: {
    code_hash : {
        eq: "43083893be7eb4c3a23c36baa2237638605c345b33907a61999634bf7f63ce4e"
      }
  },
  fields : 
  {
  field:"account_addr",
  fn:COUNT
  }
  ) 
}
```

Answer:
```
{
  "data": {
    "aggregateAccounts": [
      "2"
    ]
  }
}
```

<h2>Get all nfts on the blockchain by owner addr</h2>
If you want to get the <b>addresses</b> of your nfts, use the following example:

1. Run gettter-method from the NftRoot (resolveCodeHashIndex) but set addrRoot = address(0) (0:0000000000000000000000000000000000000000000000000000000000000000)
```
tonos-cli run 0:37f7c813a2b66c372afb5a16e707ac82572944dec80fe3ba16b4eae569b71e14 resolveCodeHashIndex '{"addrRoot": "0:0000000000000000000000000000000000000000000000000000000000000000", "addrOwner": "0:488921925e7f2d103ba1fd0af0552f180ea94ce0df7b6f82eed69d27e7882106"}' --abi NftRoot.abi.json
```

Answer:
```
Running get-method...
Succeeded.
Result: {
  "codeHashIndex": "0xebc484af3a52b0dccca8ed48da142133970a236d63c7bcddb8daeb7be0138fc1"
}
```

2. Go to the dapp with the following query:
```
query { 
    accounts 
    (filter : {
        code_hash :{eq : "ebc484af3a52b0dccca8ed48da142133970a236d63c7bcddb8daeb7be0138fc1"}
    })
{
    id
}}
```

Answer:
```
{
  "data": {
    "accounts": [
      {
        "id": "0:9b37ec7e6a52d42b253b814f11788cda261fea64a5a3dc6e303f4b945aba6546"
      },
      {
        "id": "0:db51dcbf9ba6d0001731c6944f57c701df0b6566e199b38b53fdc5e7a320618f"
      }
    ]
  }
}
```

If you want to get the <b>count</b> of your nfts, use the following example:

1. Run gettter-method from the NftRoot (resolveCodeHashIndex) but set addrRoot = address(0) (0:0000000000000000000000000000000000000000000000000000000000000000)
```
tonos-cli run 0:37f7c813a2b66c372afb5a16e707ac82572944dec80fe3ba16b4eae569b71e14 resolveCodeHashIndex '{"addrRoot": "0:0000000000000000000000000000000000000000000000000000000000000000", "addrOwner": "0:488921925e7f2d103ba1fd0af0552f180ea94ce0df7b6f82eed69d27e7882106"}' --abi NftRoot.abi.json
```

Answer:
```
Running get-method...
Succeeded.
Result: {
  "codeHashIndex": "0xebc484af3a52b0dccca8ed48da142133970a236d63c7bcddb8daeb7be0138fc1"
}
```

2. Go to the dapp with the following query:
```
query {
  aggregateAccounts(
    filter: {
    code_hash : {
        eq: "ebc484af3a52b0dccca8ed48da142133970a236d63c7bcddb8daeb7be0138fc1"
      }
  },
  fields : 
  {
  field:"account_addr",
  fn:COUNT
  }
  ) 
}
```

Answer:
```
{
  "data": {
    "aggregateAccounts": [
      "2"
    ]
  }
}
```