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
    }

    /**
        1st address = vendor address
        2nd address = user address
        MessageStruct is a list of all reviews left by this user for this vendor
    */
    mapping (address => mapping (address => MessageStruct[]))   public messages;
    mapping (address => mapping (address => uint256))           public reviewCounts;

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
    }

    function submitMessage(
        address _vendorAddress,
        bytes20 _vendorHash,
        string _ipfsMessageHash,
        string _rawMessage
    )
        public
        isRegisteredUser(msg.sender)
        isValidVendorHash(_vendorAddress, _vendorHash)
        returns (bool submitted)
    {
        MessageStruct memory m = MessageStruct({submitterAddress: msg.sender, vendorHash: _vendorHash, blockSubmittedAt: block.number, submissionDate: now, ipfsMessageHash: _ipfsMessageHash, rawMessage: _rawMessage});
        messages[_vendorAddress][msg.sender].push(m);
        reviewCounts[_vendorAddress][msg.sender] = messages[_vendorAddress][msg.sender].length;
        // event placeholder
        return true;
    }
}