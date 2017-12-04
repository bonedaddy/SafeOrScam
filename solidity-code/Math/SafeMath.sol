pragma solidity 0.4.18;


library SafeMath {

  function mul(uint128 a, uint128 b) internal pure returns (uint128) {
    uint128 c = a * b;
    require(a == 0 || c / a == b);
    return c;
  }

  function div(uint128 a, uint128 b) internal pure returns (uint128) {
    uint128 c = a / b;
    return c;
  }

  function sub(uint128 a, uint128 b) internal pure returns (uint128) {
    require(b <= a);
    return a - b;
  }

  function add(uint128 a, uint128 b) internal pure returns (uint128) {
    uint128 c = a + b;
    require(c >= a);
    return c;
  }
}