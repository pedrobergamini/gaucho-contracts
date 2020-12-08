const GauchoFactory = artifacts.require('GauchoFactory');

module.exports = function(deployer) {
  const masterChefAddress = '0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd';
  deployer.deploy(GauchoFactory, masterChefAddress);
};