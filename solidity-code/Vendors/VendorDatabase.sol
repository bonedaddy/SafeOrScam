pragma solidity 0.4.18;

import "../Modules/Administration.sol";
import "../Math/SafeMath.sol";

contract VendorDatabase is Administration {

    using SafeMath for uint;

    uint256     constant    public  VENDORFEE = 0;

    struct VendorStruct {
        address vendorAddress;
        bytes20 vendorHash;
        uint256 numberOfPositiveReviews;
        uint256 numberOfNegativeReviews;
        uint256 numberOfNeutralReviews;
        bool    accountEnabled;
    }

    mapping (address => VendorStruct) public vendors;

    modifier isNotVendorAccount(address _vendorAddress) {
        require(_vendorAddress != address(0x0));
        require(!vendors[_vendorAddress].accountEnabled);
        _;
    }

    function () payable (
        require(registerVendorAccount());
    )
    
    function registerVendorAccount()
        public
        payable
        isNotVendorAccount(msg.sender)
        returns (bool registered)
    {
        require(msg.value == VENDORFEE);
        bytes20 _vendorHash = ripemd160(msg.sender, "vendor registration", msg.sig);
        vendors[msg.sender].vendorAddress = msg.sender;
        vendors[msg.sender].vendorHash = _vendorHash;
        vendors[msg.sender].accountEnabled = true;
        // event placeholder
        return true;
    }

    function getVendorHash(
        address _vendorAddress
    )
        public
        view
        returns (bytes20)
    {
        return vendors[_vendorAddress].vendorHash;
    }

    function getNumberOfPositiveReviews(
        address _vendorAddress
    )
        public
        view
        returns (uint256)
    {
        return vendors[_vendorAddress].numberOfPositiveReviews;
    }

    function getNumberOfNegativeReviews(
        address _vendorAddress
    )
        public
        view
        returns (uint256)
    {
        return vendors[_vendorAddress].numberOfNegativeReviews;
    }

    function getNumberOfNeutralReviews(
        address _vendorAddress
    )
        public
        view
        returns (uint256)
    {
        return vendors[_vendorAddress].numberOfNeutralReviews;
    }
    
    function getAccountEnabledStatus(
        address _vendorAddress
    )
        public
        view
        returns (bool)
    {
        return vendors[_vendorAddress].accountEnabled;
    }
}