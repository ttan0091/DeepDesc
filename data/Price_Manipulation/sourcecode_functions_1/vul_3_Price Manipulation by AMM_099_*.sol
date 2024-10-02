function _pendingMIMO(uint256 _userStakeWithBoost, uint256 _userAccAmountPerShare) internal view returns (uint256) {
    if (_totalStakeWithBoost == 0) {
        return 0;
    }
    uint256 currentBalance = _a.mimo().balanceOf(address(this));
    uint256 reward = currentBalance.sub(_mimoBalanceTracker);
    uint256 accMimoAmountPerShare = _accMimoAmountPerShare.add(reward.rayDiv(_totalStakeWithBoost));
    return _userStakeWithBoost.rayMul(accMimoAmountPerShare.sub(_userAccAmountPerShare));
}