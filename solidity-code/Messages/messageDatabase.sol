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

contract MessageDatabase is Administration {

    using SafeMath for uint;
    UserDatabaseInterface public userdatabaseInterface;

    struct MessageStruct {
        address submitterAddress;
        // ripemd160 hash of the vendor
        bytes20 vendorHash;
        uint256 blockSubmittedAt;
        string  submissionDate;
        // this is hash of the message stored in ipfs (we store the contents of the message in ipfs to reduce storage costs)
        string  ipfsMessageHash;
        // until ipfs backend is in place, we will store the message contents within the contract
        string  rawMessage;
    }

    mapping (bytes20 => MessageStruct) private messages;
    
    modifier isRegisteredUser(address _userAddress) {
        require(_userAddress != address(0x0));
        require(userdatabaseInterface.getAccountEnabledStatus(_userAddress));
        _;
    }

    function MessageDatabase() {
        administrationContractFrozen = false;
    }

    function submitMessage(
        string _vendorHash,
        string _rawMessage
    )
        public
        isRegisteredUser(msg.sender)
        returns (bool submitted)
    {

        return true;
    }
}