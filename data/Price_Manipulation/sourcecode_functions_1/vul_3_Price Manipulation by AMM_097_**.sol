function _increaseStake(address user, uint256 value) internal {
    require(value > 0, "STAKE_MUST_BE_GREATER_THAN_ZERO"); // TODO: cleanup error message

    UserInfo storage userInfo = _users[user];
    _refresh();

    uint256 pending;
    if (userInfo.stake > 0) {
        pending = userInfo.stake.rayMul(_accAmountPerShare.sub(userInfo.accAmountPerShare));
        _balanceTracker = _balanceTracker.sub(pending);
    }

    totalStake = totalStake.add(value);
    userInfo.stake = userInfo.stake.add(value);
    userInfo.accAmountPerShare = _accAmountPerShare;

    if (pending > 0) {
        require(a.mimo().transfer(user, pending));
    }

    emit StakeIncreased(user, value);
}