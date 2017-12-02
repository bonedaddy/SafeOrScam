pragma solidity 0.4.18;

interface UserDatabaseInterface {
    function getNumberOfReviews(address _userAddress) public view returns (uint);
    function getNumberofPositiveReviews(address _userAddress) public view returns (uint);
    function getNumberOfNegativeReviews(address _userAddress) public view returns (uint);
    function getNumberOfNeutralReviews(address _userAddress) public view returns (uint);
    function getBanEndDate(address _userAddress) public view returns (uint);
    function getAccountEnabledStatus(address _userAddress) public view returns (bool);
    function getAccountBannedStatus(address _userAddress) public view returns (bool);
}