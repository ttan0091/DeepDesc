
function pendingReward(address _user)
    external
    view
    returns (uint256)
{
    uint256 rewardShare = accRewardPerShare;
    uint256 staked = totalStaked;
    // if blockNumber is greater than the pool's `lastRewardBlock` the pool's `accRewardPerShare` is outdated
    // we need to calculate the up-to-date amount to return an accurate reward value
    if (block.number > lastRewardBlock && staked > 0) {
        (rewardShare, ) = _computeUpdate();
    }
    return
        // rewards that the user had already accumulated but not claimed
        userPendingRewards[_user] +
        // subtracting the user's `lastAccRewardPerShare` from the pool's `accRewardPerShare` results in the
        // rewards the pool has accumulated since the user's last claim, multiplying it by the user's shares
        // results in the rewards owed to the user
        (balanceOf[_user] * (rewardShare - userLastAccRewardPerShare[_user])) /
        1e36;
}