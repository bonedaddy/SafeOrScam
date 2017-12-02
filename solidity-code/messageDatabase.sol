pragma solidity 0.4.18;

/**
    Message database for SafeOrDapp
*/

import "./Modules/Administration.sol";
import "./Math/SafeMath.sol";

contract MessageDatabase is Administration {

    using SafeMath for uint;


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

    function MessageDatabase() {
        administrationContractFrozen = false;
    }

}