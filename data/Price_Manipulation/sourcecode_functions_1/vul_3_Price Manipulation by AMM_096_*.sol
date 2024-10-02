function _refresh() internal {
    if (totalStake == 0) {
        return;
    }
    uint256 currentBalance = a.mimo().balanceOf(address(this));
    uint256 reward = currentBalance.sub(_balanceTracker);
    _balanceTracker = currentBalance;

    _accAmountPerShare = _accAmountPerShare.add(reward.rayDiv(totalStake));
}