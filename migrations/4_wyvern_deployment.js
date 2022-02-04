const WyvernRegistry = artifacts.require('./WyvernRegistry.sol')
const WyvernExchange = artifacts.require('./WyvernExchange.sol')

const chainIds = {
  development: 1335,
  rinkeby: 4,
  ropsten: 3,
  mumbai: 80001,
  main: 1,
  polygon: 137
}

const personalSignPrefixes = {
  default: "\x19Ethereum Signed Message:\n",
  klaytn: "\x19Klaytn Signed Message:\n",
  baobab: "\x19Klaytn Signed Message:\n"
}

module.exports = async (deployer, network) => {
  await deployer.deploy(WyvernRegistry);

  const personalSignPrefix = personalSignPrefixes[network] || personalSignPrefixes['default'];

  // TODO: edit registry
  await deployer.deploy(WyvernExchange,
    chainIds[network],
    [WyvernRegistry.address, '0xa5409ec958C83C3f309868babACA7c86DCB077c1'],
    Buffer.from(personalSignPrefix, 'binary')
  );

  const registry = await WyvernRegistry.deployed();
  await registry.grantInitialAuthentication(WyvernExchange.address);
}
