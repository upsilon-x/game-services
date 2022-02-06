const ProjectNFT = artifacts.require("ProjectNFT");
const AchievementAggregator = artifacts.require("AchievementAggregator");

module.exports = async function (deployer) {
  let nft = await ProjectNFT.deployed();
  await deployer.deploy(AchievementAggregator, nft.address);
};
