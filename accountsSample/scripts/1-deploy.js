const getRandomNonce = () => Math.random() * 64000 | 0;


async function main() {

  const AccountFactory = await locklift.factory.getContract('AccountFactory');
  const Account = await locklift.factory.getContract('Account');
  const [keyPair] = await locklift.keys.getKeyPairs();
  const owner = "0:15351e150f780bac9e1ce3c9fc4c84d5b9288bffb3153409e7bfdf39d42a9e30";

  
  
  const accountFactory = await locklift.giver.deployContract({
    contract: AccountFactory,
    constructorParams: {
      codeAccount: Account.code, 
      owner: owner
    },
    initParams: {
      _nonce: getRandomNonce(),
    },
    keyPair,
  }, locklift.utils.convertCrystal(1, 'nano'));
  
  console.log(`AccountFactory deployed at: ${accountFactory.address}`);
}


main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });
