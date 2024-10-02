function deposit(uint256 _pid, uint256 _amount) public {
    PoolInfo storage pool = poolInfo[_pid];
    UserInfo storage user = userInfo[_pid][msg.sender];
    updatePool(_pid);
    if (user.amount > 0) {
        uint256 pending = user.amount.mul(pool.accRewardsPerShare).div(1e12).sub(user.rewardDebt);
        if (pending > 0) {
            totalRewardDebt = totalRewardDebt.sub(pending);
            safeRewardsTransfer(msg.sender, pending);
        }
    }
    if (_amount > 0) {
        pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
        user.amount = user.amount.add(_amount);
    }
    user.rewardDebt = user.amount.mul(pool.accRewardsPerShare).div(1e12);
    emit Deposit(msg.sender, _pid, _amount);
}