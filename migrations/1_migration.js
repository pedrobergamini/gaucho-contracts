const GauchoFactory = artifacts.require('GauchoFactory');

module.exports = function(deployer) {
  const masterChefAddress = '0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd';
  const sushiAddress = '0x6b3595068778dd592e39a122f4f5a5cf09c90fe2';

  deployer.deploy(GauchoFactory, masterChefAddress, sushiAddress);
};