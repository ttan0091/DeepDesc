function retrieveUnsoldTokens() safeTimelock ownerOnly returns(bool success) {
        uint256 amountOfTokens = balanceOf[crowdFundAddress];
        balanceOf[crowdFundAddress] = 0;
        balanceOf[incentivisationFundAddress] = safeAdd(balanceOf[incentivisationFundAddress], amountOfTokens);
        totalAllocated = safeAdd(totalAllocated, amountOfTokens);
        Transfer(crowdFundAddress, incentivisationFundAddress, amountOfTokens);
        return true;
    }