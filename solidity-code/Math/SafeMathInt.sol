pragma solidity 0.4.18;


library SafeMathInt {

  function mul(int128 a, int128 b) internal pure returns (int128) {
    int128 c = a * b;
    require(a == 0 || c / a == b);
    return c;
  }

  function div(int128 a, int128 b) internal pure returns (int128) {
    int128 c = a / b;
    return c;
  }

  function sub(int128 a, int128 b) internal pure returns (int128) {
    require(b <= a);
    return a - b;
  }

  function add(int128 a, int128 b) internal pure returns (int128) {
    int128 c = a + b;
    require(c >= a);
    return c;
  }
}