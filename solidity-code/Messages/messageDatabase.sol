pragma solidity 0.4.18;

/**
    Message database for SafeOrDapp


    function getNumberOfReviews(address _userAddress) public view returns (uint);
    function getNumberofPositiveReviews(address _userAddress) public view returns (uint);
    function getNumberOfNegativeReviews(address _userAddress) public view returns (uint);
    function getNumberOfNeutralReviews(address _userAddress) public view returns (uint);
    function getBanEndDate(address _userAddress) public view returns (uint);
    function getAccountEnabledStatus(address _userAddress) public view returns (bool);
    function getAccountBannedStatus(address _userAddress) public view returns (bool);
*/

import "../Modules/Administration.sol";
import ".././Math/SafeMath.sol";
import "../interfaces/UserDatabaseInterface.sol";
import "../interfaces/VendorDatabaseInterface.sol";


contract MessageDatabase is Administration {

    using SafeMath for uint;
    UserDatabaseInterface public userdatabaseInterface;
    VendorDatabaseInterface public vendordatabaseInterface;
    bytes20[]       public reviewTypes;

    struct MessageStruct {
        address submitterAddress;
        // ripemd160 hash of the vendor
        bytes20 vendorHash;
        uint256 blockSubmittedAt;
        uint256  submissionDate;
        // this is hash of the message stored in ipfs (we store the contents of the message in ipfs to reduce storage costs)
        string  ipfsMessageHash;
        // until ipfs backend is in place, we will store the message contents within the contract
        string  rawMessage;
        bytes20 reviewType;
    }

    struct ReviewStatistics {
        address vendorAddress;
        address submitterAddress;
        uint256 totalNumberOfReviews;
        uint256 numberOfPositiveReviews;
        uint256 numberOfNegativeReviews;
        uint256 numberOfNeutralReviews;
    }

    struct GeneralizedReviewStruct {
        address vendorAddress;
        uint256 totalNumberOfReviews;
        uint256 numberOfPositiveReviews;
        uint256 numberOfNegativeReviews;
        uint256 numberOfNeutralReviews;
    }

    function getTotalNumberOfReviews(
        address _vendorAddress
    )
        public
        view
        returns (uint256)
    {
        return vendors[_vendorAddress].totalNumberOfReviews;
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

    /**
        1st address = vendor address
        2nd address = user address
        MessageStruct is a list of all reviews left by this user for this vendor
    */
    mapping (address => mapping (address => MessageStruct[]))   public messages;
    mapping (address => mapping (address => ReviewStatistics))           public reviewCounts;
    mapping (address => GeneralizedReviewStruct)    public vendors;

    modifier isRegisteredUser(address _userAddress) {
        require(_userAddress != address(0x0));
        require(userdatabaseInterface.getAccountEnabledStatus(_userAddress));
        _;
    }

    modifier isValidVendorHash(address _vendorAddress, bytes20 _vendorHash) {
        require(_vendorAddress != address(0x0));
        require(vendordatabaseInterface.checkIfValidVendorHash(_vendorAddress, _vendorHash));
        _;
    
    }
    function MessageDatabase() {
        administrationContractFrozen = false;
        bytes20 _positive = ripemd160("positive");
        bytes20 _negative = ripemd160("negaitve");
        bytes20 _neutral = ripemd160("neutral");
        reviewTypes[0] = _positive;
        reviewTypes[1] = _negative;
        reviewTypes[2] = _neutral;
    }


    function checkIfValidReviewType(
        bytes20 _reviewType
    )
        public
        view
        returns (bool)
    {
        if (_reviewType == reviewTypes[0] || _reviewType == reviewTypes[1] || _reviewType == reviewTypes[2]) {
            return true;
        } else {
            return false;
        }
    }

    function submitMessage(
        address _vendorAddress,
        bytes20 _vendorHash,
        bytes20 _reviewType,
        string _ipfsMessageHash,
        string _rawMessage
    )
        public
        isRegisteredUser(msg.sender)
        isValidVendorHash(_vendorAddress, _vendorHash)
        returns (bool submitted)
    {
        require(checkIfValidReviewType(_reviewType));
        MessageStruct memory m = MessageStruct({submitterAddress: msg.sender, vendorHash: _vendorHash, blockSubmittedAt: block.number, submissionDate: now, ipfsMessageHash: _ipfsMessageHash, rawMessage: _rawMessage, reviewType: _reviewType});
        messages[_vendorAddress][msg.sender].push(m);
        if (_reviewType == reviewTypes[0]) { //positive
            reviewCounts[_vendorAddress][msg.sender].numberOfPositiveReviews = reviewCounts[_vendorAddress][msg.sender].numberOfPositiveReviews.add(1);
        } else if (_reviewType == reviewTypes[1]) { // negative
            reviewCounts[_vendorAddress][msg.sender].numberOfNegativeReviews = reviewCounts[_vendorAddress][msg.sender].numberOfNegativeReviews.add(1);
        } else if (_reviewType == reviewTypes[2]) { // neutral
            reviewCounts[_vendorAddress][msg.sender].numberOfNeutralReviews = reviewCounts[_vendorAddress][msg.sender].numberOfNeutralReviews.add(1);
        } else {
            return false;
        }
        reviewCounts[_vendorAddress][msg.sender].totalNumberOfReviews = reviewCounts[_vendorAddress][msg.sender].totalNumberOfReviews.add(1);
        // event placeholder
        return true;
    }
}