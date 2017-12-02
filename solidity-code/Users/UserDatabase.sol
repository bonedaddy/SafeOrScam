pragma solidity 0.4.18;

/**
    User Database for SafeOrDapp
*/

import "../Modules/Administration.sol";
import "../Math/SafeMath.sol";

contract UserDatabase is Administration {

    using SafeMath for uint;

    uint256 public  registrationFee;

    struct UserStruct {
        address userAddress;
        uint256 numberOfReviews;
        uint256 numberOfPositiveReviews;
        uint256 numberOfNegativeReviews;
        uint256 numberOfNeutralReviews;
        uint256 banEndDate;
        bool    accountEnabled;
        bool    accountBanned;
    }



    mapping (address => UserStruct) public users;

    modifier hasValidRegistrationFee() {
        require(msg.value == registrationFee);
        _;
    }

    modifier isRegisteredUser(address _userAddress) {
        require(_userAddress != address(0x0));
        require(users[_userAddress].accountEnabled);
        _;
    }

    function UserDatabase() {
        administrationContractFrozen = false;
        // 0.001ETH in wei
        registrationFee = 1000000000000000;
    }

    function () payable {
        require(registerUser());
    }

    function registerUser()
        public
        payable
        onlyAdmin
        hasValidRegistrationFee
        returns (bool registered)
    {
        users[msg.sender].userAddress = msg.sender;
        users[msg.sender].accountEnabled = true;
        users[msg.sender].accountBanned = false;
        // event placeholder
        return true;
    }

    function banUser(
        address _userAddress,
        uint256 _banDuration
    )
        public
        onlyAdmin
        isRegisteredUser(_userAddress)
        returns (bool banned)
    {
        require(_banDuration > 0);
        uint256 _endDate = now + _banDuration * 1 days;
        users[_userAddress].accountBanned = true;
        users[_userAddress].banEndDate = _endDate;
        // event placeholder
        return true;
    }

    function unBanUser(
        address _userAddress
    )
        public
        onlyAdmin
        isRegisteredUser(_userAddress)
        returns (bool unbanned)
    {
        users[_userAddress].accountBanned = false;
        users[_userAddress].banEndDate = 0;
        // event placeholder
        return true;
    }

    function increaseNumberOfReviews(
        address _userAddress,
        uint256 _amountToIncreaseBy
    )
        public
        onlyAdmin
        isRegisteredUser(_userAddress)
        returns (bool increased)
    {
        require(_amountToIncreaseBy > 0);
        require(users[_userAddress].numberOfReviews.add(_amountToIncreaseBy) > users[_userAddress].numberOfReviews);
        users[_userAddress].numberOfReviews = users[_userAddress].numberOfReviews.add(_amountToIncreaseBy);
        // event placeholder
        return true;
    }

    function increaseNumberOfPositiveReviews(
        address _userAddress,
        uint256 _amountToIncreaseBy
    )
        public
        onlyAdmin
        isRegisteredUser(_userAddress)
        returns (bool increased)
    {
        require(_amountToIncreaseBy > 0);
        require(users[_userAddress].numberOfPositiveReviews.add(_amountToIncreaseBy) > users[_userAddress].numberOfPositiveReviews);
        users[_userAddress].numberOfPositiveReviews = users[_userAddress].numberOfPositiveReviews.add(_amountToIncreaseBy);
        // event placeholder
        return true;
    }

    function increaseNumberOfNegativeReviews(
        address _userAddress,
        uint256 _amountToIncreaseBy
    )
        public
        onlyAdmin
        isRegisteredUser(_userAddress)
        returns (bool increased)
    {
        require(_amountToIncreaseBy > 0);
        require(users[_userAddress].numberOfNegativeReviews.add(_amountToIncreaseBy) > users[_userAddress].numberOfNegativeReviews);
        users[_userAddress].numberOfNegativeReviews = users[_userAddress].numberOfNegativeReviews.add(_amountToIncreaseBy);
        // event placeholder
        return true;
    }

    function increaseNumberOfNeutralReviews(
        address _userAddress,
        uint256 _amountToIncreaseBy
    )
        public
        onlyAdmin
        isRegisteredUser(_userAddress)
        returns (bool increased)
    {
        require(_amountToIncreaseBy > 0);
        require(users[_userAddress].numberOfNeutralReviews.add(_amountToIncreaseBy) > users[_userAddress].numberOfNeutralReviews);
        users[_userAddress].numberOfNeutralReviews = users[_userAddress].numberOfNeutralReviews.add(_amountToIncreaseBy);
        // event placeholder
        return true;
    }
    
    /**GETTERS */
    function getNumberOfReviews(
        address _userAddress
    )
        public
        view
        returns (uint)
    {
        return users[_userAddress].numberOfReviews;
    }

    function getNumberofPositiveReviews(
        address _userAddress
    )
        public
        view
        returns (uint)
    {
        return users[_userAddress].numberOfPositiveReviews;
    }

    function getNumberOfNegativeReviews(
        address _userAddress
    )
        public
        view
        returns (uint)
    {
        return users[_userAddress].numberOfNegativeReviews;
    }

    function getNumberOfNeutralReviews(
        address _userAddress
    )
        public
        view
        returns (uint)
    {
        return users[_userAddress].numberOfNeutralReviews;
    }

    function getBanEndDate(
        address _userAddress
    )
        public
        view
        returns (uint)
    {
        return users[_userAddress].banEndDate;
    }
    
    function getAccountEnabledStatus(
        address _userAddress
    )
        public
        view
        returns (bool)
    {
        return users[_userAddress].accountEnabled;
    }

    function getAccountBannedStatus(
        address _userAddress
    )
        public
        view
        returns (bool)
    {
        return users[_userAddress].accountBanned;
    }

}