// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/access/Ownable.sol';

/// @title Factory responsible for creating GauchoVaults
/// @author Pedro Bergamini
/// @notice Gaucho.finance is in very early alpha and under development
contract GauchoFactory is Ownable {

  address[] allVaults;

  event VaultCreated(address indexed uniPool, address indexed sushiPool);

  function allVaultsLength() external view returns (uint) {
    return allVaults.length;
  }

  function createVault(address _uniPool, address _sushiPool) external onlyOwner {
    
  }
}