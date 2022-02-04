const WyvernAtomicizer = artifacts.require('./WyvernAtomicizer.sol');
const WyvernStatic = artifacts.require('./WyvernStatic.sol');
const StaticMarket = artifacts.require('./StaticMarket.sol');
const TestERC20 = artifacts.require('./TestERC20.sol');
const TestERC721 = artifacts.require('./TestERC721.sol');
const TestERC1271 = artifacts.require('./TestERC1271.sol');
const TestAuthenticatedProxy = artifacts.require('./TestAuthenticatedProxy.sol');

module.exports = async (deployer, network) => {
  await deployer.deploy(WyvernAtomicizer);
  await deployer.deploy(WyvernStatic, WyvernAtomicizer.address);
  await deployer.deploy(StaticMarket);

  if (network !== 'coverage' && network !== 'development') return;
  else {
    await deployer.deploy(TestERC20);
    await deployer.deploy(TestERC721);
    await deployer.deploy(TestAuthenticatedProxy);
    await deployer.deploy(TestERC1271);
  }
}

