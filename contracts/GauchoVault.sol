// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract GauchoVault is ERC20 {
  bool public isPaused;

  address public owner;

  // Uniswap pair address
  address public uniPool;

  // Sushiswap pair address
  address public sushiPool;

  modifier onlyOwner() {
    require(msg.sender == owner, 'Error: Not owner');
    _;
  }

  modifier notPaused() {
    require(!isPaused, 'Error: contract circuit breaker activated');
    _;
  }


  constructor(address _uniPool, address _sushiPool, string name, string symbol, address _owner) public {
    super(name, symbol);        
    uniPool = _uniPool;
    sushiPool = _sushiPool;
    owner = _owner;
  }

  function setIsPaused(bool _isPaused) external onlyOwner {
    isPaused = _isPaused;
  }

  function deposit() external notPaused {}

  function withdraw() external notPaused {}

  function harvestRewards() external notPaused {}

  function switchPool() external notPaused {}

  function getHigherAPY() public view returns (address) {}
}