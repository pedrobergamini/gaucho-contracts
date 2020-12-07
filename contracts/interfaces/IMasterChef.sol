pragma solidity >= 0.6.0;

interface IMasterChef {
  function pendingSushi(uint256 _pid, address _user) external view returns (uint256);
  function deposit(uint256 _pid, uint256 _amount) external;
  function withdraw(uint256 _pid, uint256 _amount) external;
}