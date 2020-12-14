// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import './interfaces/IMasterChef.sol';
import './interfaces/IGauchoCaller.sol';

/// @title Gaucho Vault liquidity token
/// @author Pedro Bergamini
/// @notice Gaucho.finance is in very early alpha and not production ready
contract GauchoVault is ERC20('GauchoVault', 'GVAU') {
  using SafeERC20 for IERC20;
  using SafeMath for uint;

  bool public isPaused;

  address public owner;

  IERC20 public lpToken;

  IERC20 public sushiToken;

  IMasterChef public masterchef;

  uint public pid;

  modifier onlyOwner() {
    require(msg.sender == owner, 'Error: Not owner');
    _;
  }

  modifier notPaused() {
    require(!isPaused, 'Error: contract circuit breaker activated');
    _;
  }

  event Deposit(address user, uint amount);

  event Withdraw(address user, uint amount);

  event FlashHarvest(address user, address userContract, uint amount);

  constructor(IERC20 _lpToken, IERC20 _sushiToken, IMasterChef _masterchef, uint _pid, address _owner) public {
    lpToken = _lpToken;
    sushiToken = _sushiToken;
    owner = _owner;
    masterchef = _masterchef;
    pid = _pid;
  }

// @notice Triggers circuit breaker
  function setIsPaused(bool _isPaused) external onlyOwner {
    isPaused = _isPaused;
  }

  // @notice Deposits lp tokens and mints Vault shares
  function deposit(uint _amount) external notPaused {
    require(_amount > 0, 'Error: no 0 amount');

    lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
    masterchef.deposit(pid, _amount);

    uint totalLpTokens = lpToken.balanceOf(address(this));
    uint totalShares = totalSupply();
    
    if (totalShares == 0 || totalLpTokens == 0) {
        _mint(msg.sender, _amount);
    } 
    
    else {
        uint amountToMint = _amount.mul(totalShares).div(totalLpTokens);
        _mint(msg.sender, amountToMint);
    }

    emit Deposit(msg.sender, _amount);
  }

  // @notice Withdraw user lp tokens from MasterChef and burns his shares
  function withdraw(uint _amount) external notPaused {
    require(_amount > 0, 'Error: no 0 amount');

    uint256 totalShares = totalSupply();  
    uint totalLpTokens = lpToken.balanceOf(address(this));  
    uint256 amountToSend = _amount.mul(totalLpTokens).div(totalShares);
    _burn(msg.sender, _amount);

    masterchef.withdraw(pid, amountToSend);
    lpToken.transfer(msg.sender, amountToSend);

    emit Withdraw(msg.sender, _amount);
  }

  function flashHarvest(uint _amount, address _receiver, bytes calldata _data) external notPaused {
    uint balance = sushiToken.balanceOf(address(this));
    require(balance >= _amount, 'Error: not enough sushi balance');
    
    sushiToken.transfer(_receiver, _amount);
    IGauchoCaller(_receiver).gauchoFlashHarvest(msg.sender, _amount, _data);
    // requires amount and 0.3% fee to be paid
    uint requiredBalance = balance.sub(_amount).add(_amount.div(10).mul(13));
    uint balancePostExecution = sushiToken.balanceOf(address(this));
    
    // reverts if insufficient amount was returned after caller contract execution
    require(balancePostExecution == requiredBalance, 'Error: Insufficient amount returned');

    emit FlashHarvest(msg.sender, _receiver, _amount);
  }

}