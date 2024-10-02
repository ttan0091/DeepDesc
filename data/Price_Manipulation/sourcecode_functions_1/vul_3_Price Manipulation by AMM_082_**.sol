function updatePool() public {
    if (block.timestamp <= lastRewardTimestamp) {
        return;
    }
    uint256 joeSupply = joe.balanceOf(address(this));
    if (joeSupply == 0) {
        lastRewardTimestamp = block.timestamp;
        return;
    }
    uint256 multiplier = block.timestamp - lastRewardTimestamp;
    uint256 rJoeReward = multiplier * rJoePerSec;
    accRJoePerShare =
        accRJoePerShare +
        (rJoeReward * PRECISION) /
        joeSupply;
    lastRewardTimestamp = block.timestamp;
    rJoe.mint(address(this), rJoeReward);
}