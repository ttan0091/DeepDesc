function pendingRewards(uint256 _pid, address _user) external view returns (uint256) {
    PoolInfo storage pool = poolInfo[_pid];
    UserInfo storage user = userInfo[_pid][_user];
    uint256 accRewardsPerShare = pool.accRewardsPerShare;
    uint256 lpSupply = pool.lpToken.balanceOf(address(this));
    if (block.number > pool.lastRewardBlock && lpSupply != 0) {
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 rewardsAccum = multiplier.mul(rewardsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        accRewardsPerShare = accRewardsPerShare.add(rewardsAccum.mul(1e12).div(lpSupply));
    }
    return user.amount.mul(accRewardsPerShare).div(1e12).sub(user.rewardDebt);
}