function collectRentUser(address _user, uint256 _timeToCollectTo)
    public
    override
    returns (uint256 newTimeLastCollectedOnForeclosure)
{
    require(!globalPause, "Global pause is enabled");
    assert(_timeToCollectTo != 0);

    if (user[_user].lastRentCalc < _timeToCollectTo) {
        uint256 rentOwedByUser = rentOwedUser(_user, _timeToCollectTo);

        if (rentOwedByUser > 0 && rentOwedByUser > user[_user].deposit) {
            // The user has run out of deposit already.
            uint256 previousCollectionTime = user[_user].lastRentCalc;

            uint256 timeUsersDepositLasts = 
                ((_timeToCollectTo - previousCollectionTime) * 
                uint256(user[_user].deposit)) / rentOwedByUser;

            // Users last collection time = previousCollectionTime + timeTheirDepositLasted
            rentOwedByUser = uint256(user[_user].deposit);
            newTimeLastCollectedOnForeclosure = 
                previousCollectionTime + timeUsersDepositLasts;

            _increaseMarketBalance(rentOwedByUser, _user);
            user[_user].lastRentCalc = SafeCast.toUint64(newTimeLastCollectedOnForeclosure);
            assert(user[_user].deposit == 0);
            isForeclosed[_user] = true;
            emit LogUserForeclosed(_user, true);
        } else {
            // User has enough deposit to pay rent.
            _increaseMarketBalance(rentOwedByUser, _user);
            user[_user].lastRentCalc = SafeCast.toUint64(_timeToCollectTo);
        }
        emit LogAdjustDeposit(_user, rentOwedByUser, false);
    }
}