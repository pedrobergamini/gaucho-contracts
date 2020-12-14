pragma solidity >= 0.6.0;

interface IGauchoCaller {
  function gauchoFlashHarvest(address sender, uint amount, bytes calldata data) external;
}