function claimAllReward() external {
    require(userInfo[msg.sender].userStakeList.length > 0, 'no stake');
    require(!black[msg.sender], 'black');
    uint[] storage list = userInfo[msg.sender].userStakeList;
    uint rew;
    uint outAmount;
    uint range = list.length;
    for (uint i = 0; i < range; i++) {
        UserSlot storage info = userSlot[msg.sender][list[i - outAmount]];
        require(info.totalQuota != 0, 'wrong index');
        uint quota = (block.timestamp - info.claimTime) * info.rates;
        if (quota >= info.leftQuota) {
            quota = info.leftQuota;
        }
        rew += quota * 1e18 / getEGDPrice();
        info.claimTime = block.timestamp;
        info.leftQuota -= quota;
        info.claimedQuota += quota;
        if (info.leftQuota == 0) {
            userInfo[msg.sender].totalAmount -= info.totalQuota;
            delete userSlot[msg.sender][list[i - outAmount]];
            list[i - outAmount] = list[list.length - 1];
            list.pop();
            outAmount++;
        }
    }
    userInfo[msg.sender].userStakeList = list;
    EGD.transfer(msg.sender, rew);
    userInfo[msg.sender].totalClaimed += rew;
    emit Claim(msg.sender, rew);
}