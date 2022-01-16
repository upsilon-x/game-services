const ProjectNFT = artifacts.require("ProjectNFT");
const Multicall = artifacts.require("Multicall");

module.exports = function (deployer, network) {
  deployer.deploy(ProjectNFT);

  if (network == "development") {
    deployer.deploy(Multicall);
  }
};
