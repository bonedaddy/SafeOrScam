pragma solidity 0.4.18;

import "../Modules/Administration.sol";
import "../Math/SafeMath.sol";

contract VendorDatabase is Administration {

    using SafeMath for uint;

    uint256         constant    public  VENDORFEE = 0;
    uint256         constant    public  DEFAULTINACTIVITYPERIOD = 30 days;
    address[]                   public  vendorAddresses;

    struct VendorStruct {
        address vendorAddress;
        bytes20 vendorHash;
        uint256 numberOfPositiveReviews;
        uint256 numberOfNegativeReviews;
        uint256 numberOfNeutralReviews;
        uint256 dateOfLastActivity;
        bool    accountEnabled;
    }

    mapping (address => VendorStruct) public vendors;

    modifier isNotVendorAccount(address _vendorAddress) {
        require(_vendorAddress != address(0x0));
        require(!vendors[_vendorAddress].accountEnabled);
        _;
    }

    function () payable {
        require(registerVendorAccount());
    }

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
        vendors[msg.sender].dateOfLastActivity = now;
        // event placeholder
        return true;
    }

    /**
        @dev Going to move this off-chain in the future
    */
    function checkVendorsForInactivity()
        public
        onlyAdmin
        returns (bool checked)
    {
        uint256 _maxDate;
        for (uint i = 0; i < vendorAddresses.length; i++) {
            _maxDate = vendors[vendorAddresses[i]].dateOfLastActivity + DEFAULTINACTIVITYPERIOD;
            if (now > _maxDate) {vendors[vendorAddresses[i]].accountEnabled = false;}
        }
        return true;
    }
    /**GETTERS */

    function getActiveVendorAccounts()
        public
        view
        returns (address[])
    {
        address[] memory a;
        for (uint i = 0; i < vendorAddresses.length; i++) {
            if (vendors[vendorAddresses[i]].accountEnabled) {
                a[i] = vendorAddresses[i];
            }
        }
        return a;
    }

    function getInactiveVendorAccounts()
        public
        view
        returns (address[])
    {
        address[] memory a;
        for (uint i = 0; i < vendorAddresses.length; i++) {
            if (!vendors[vendorAddresses[i]].accountEnabled) {
                a[i] = vendorAddresses[i];
            }
        }
        return a;
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