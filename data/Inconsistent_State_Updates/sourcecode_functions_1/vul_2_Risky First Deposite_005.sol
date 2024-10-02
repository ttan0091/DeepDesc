function updatePool(uint256 _pid) public {
    PoolInfo storage pool = poolInfo[_pid];
    if (block.number <= pool.lastRewardBlock) {
        return;
    }
    uint256 lpSupply = pool.lpToken.balanceOf(address(this));
    if (lpSupply == 0) {
        pool.lastRewardBlock = block.number;
        return;
    }
    uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
    uint256 rewardsAccum = multiplier.mul(rewardsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
    if (devPercentage > 0) {
        tips = tips.add(rewardsAccum.mul(devPercentage).div(1000));
    }
    totalRewardDebt = totalRewardDebt.add(rewardsAccum);
    pool.accRewardsPerShare = pool.accRewardsPerShare.add(rewardsAccum.mul(1e12).div(lpSupply));
    pool.lastRewardBlock = block.number;
}