function stake(
    PoolStorage.Base storage ps,
    uint256 _amount,
    address _receiver
) external returns (uint256 lock) {
    uint256 totalLock = ps.lockToken.totalSupply();
    if (totalLock == 0) {
        // mint initial lock
        lock = 10**18;
    } else {
        // mint lock based on funds in pool
        lock = _amount.mul(totalLock).div(stakeBalance(ps));
    }
    ps.stakeBalance = ps.stakeBalance.add(_amount);
    ps.lockToken.mint(_receiver, lock);
}