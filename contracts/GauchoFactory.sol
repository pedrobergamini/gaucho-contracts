// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import './interfaces/IMasterChef.sol';
import './GauchoVault.sol';

/// @title Factory responsible for creating GauchoVaults
/// @author Pedro Bergamini
/// @notice Gaucho.finance is in very early alpha and not production ready
contract GauchoFactory is Ownable {

  address[] allVaults;

  IMasterChef public masterchef;

  IERC20 public sushiToken;

  event VaultCreated(address indexed vaultAddress, address indexed lpToken);

  constructor(IMasterChef _masterchef, IERC20 _sushiToken) public {
    masterchef = _masterchef;
    sushiToken = _sushiToken;
  }

  // @notice Returns vaults array length
  function allVaultsLength() external view returns (uint) {
    return allVaults.length;
  }

  // @notice creates a new Vault contract
  function createVault(IERC20 _lpToken, uint _pid) external onlyOwner {
    GauchoVault newVault = new GauchoVault(_lpToken, sushiToken, masterchef, _pid, owner());
    allVaults.push(address(newVault));
    emit VaultCreated(address(newVault), address(_lpToken));
  }
}