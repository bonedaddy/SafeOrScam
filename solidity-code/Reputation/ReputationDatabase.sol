pragma solidity 0.4.18;

import "../Modules/Administration.sol";
import "../Math/SafeMath.sol";
import "../Math/SafeMathInt.sol";

interface MessageDatabaseInterface {
    function getTotalNumberOfReviews(address _vendorAddress) public view returns (uint128);
    function getNumberOfPositiveReviews(address _vendorAddress) public view returns (uint128);
    function getNumberOfNegativeReviews(address _vendorAddress) public view returns (uint128);
    function getNumberOfNeutralReviews(address _vendorAddress) public view returns (uint128);
}
contract ReputationDatabase is Administration {

    using SafeMath for uint128;
    using SafeMathInt for int128;

    int128      constant        public  POSITIVEREVIEWWEIGHT = 1000000000000000000;
    int128      constant        public  NEGATIVEREVIEWWEIGHT  = -1000000000000000000;
    int128      constant        public  NEUTRALREVIEWWEIGHT =  -250000000000000000;
    MessageDatabaseInterface                     public  messageDatabaseInterface;

    struct ReputationStruct {
        address vendorAddress;
        int128 reputationScore;
    }

    mapping (address => ReputationStruct) public reputation;

    function calculateRepuation(
        address _vendorAddress
    )
        external
        returns (bool calculated)
    {
        uint128 _numPositiveReviews = messageDatabaseInterface.getNumberOfPositiveReviews(_vendorAddress);
        int128 numPositiveReviews = int128(_numPositiveReviews);
        uint128 _numNegativeReviews = messageDatabaseInterface.getNumberOfNegativeReviews(_vendorAddress);
        int128 numNegativeReviews = int128(_numNegativeReviews);
        uint128 _numNeutralReviews = messageDatabaseInterface.getNumberOfNeutralReviews(_vendorAddress);
        int128 numNeutralReviews = int128(_numNeutralReviews);
        int128 positiveWeight = POSITIVEREVIEWWEIGHT.mul(numPositiveReviews);
        int128 negativeWeight = NEGATIVEREVIEWWEIGHT.mul(numNegativeReviews);
        int128 neutralWeight = NEUTRALREVIEWWEIGHT.mul(numNeutralReviews);
        int128 sumPositiveNegative = positiveWeight.add(negativeWeight);
        int128 rep = sumPositiveNegative.add(neutralWeight);
        reputation[_vendorAddress].reputationScore = rep;
    }
}