function _computeUpdate() internal view returns (uint256 newAccRewardsPerShare, uint256 currentBala){
    currentBalance = vault.balanceOfJPEG() + jpeg.balanceOf(address(this));
    uint256 newRewards = currentBalance - previousBalance;
    newAccRewardsPerShare = accRewardPerShare + newRewards * 1e36 / totalStaked;
}