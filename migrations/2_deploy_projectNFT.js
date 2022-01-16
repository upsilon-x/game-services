const ProjectNFT = artifacts.require("ProjectNFT");
const UpdatedMulticall = artifacts.require("UpdatedMulticall");

module.exports = function (deployer, network) {
  deployer.deploy(ProjectNFT);

  if (network == "development") {
    deployer.deploy(UpdatedMulticall);
  }
};
