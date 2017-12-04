pragma solidity 0.4.18;

import "../Modules/Administration.sol";
import "../Math/SafeMath.sol";


interface MessageDatabaseInterface {
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
    ) public view returns (uint256);
}
contract ReputationDatabase is Administration {

    using SafeMath for uint;
    using SafeMathInt for int;

    int256      constant        public  POSITIVEREVIEWWEIGHT = 1000000000000000000;
    int256      constant        public  NEGATIVEREVIEWEIGHT  = -1000000000000000000;
    int256      constant        public  NEUTRALREVIEWWEIGHT =  -250000000000000000;
    struct ReputationStruct {
        address vendorAddress;
        bytes20 vendorHash;
        int256 reputation;
    }
}