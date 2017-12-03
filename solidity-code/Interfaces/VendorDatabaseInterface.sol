pragma solidity 0.4.18;

interface VendorDatabaseInterface {
        /**GETTERS */
    function getActiveVendorAccounts() public view returns (address[]); 
    function getInactiveVendorAccounts() public view returns (address[]);
    function getVendorHash(address _vendorAddress) public view returns (bytes20);
    function getNumberOfPositiveReviews(address _vendorAddress) public view returns (uint256);
    function getNumberOfNegativeReviews(address _vendorAddress) public view returns (uint256); 
    function getNumberOfNeutralReviews( address _vendorAddress) public view returns (uint256);
    function getAccountEnabledStatus(address _vendorAddress) public view returns (bool);
    function checkIfValidVendorHash(address _vendorAddress, bytes20 _vendorHash) public view returns (bool);
}