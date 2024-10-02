function ENJToken(address _crowdFundAddress, address _advisorAddress, address _incentivisationFundAddress, address _enjinTeamAddress)
    ERC20Token("Enjin Coin", "ENJ", 18)
     {
        crowdFundAddress = _crowdFundAddress;
        advisorAddress = _advisorAddress;
        enjinTeamAddress = _enjinTeamAddress;
        incentivisationFundAddress = _incentivisationFundAddress;
        balanceOf[_crowdFundAddress] = minCrowdsaleAllocation + maxPresaleSupply; // Total presale + crowdfund tokens
        balanceOf[_incentivisationFundAddress] = incentivisationAllocation;       // 10% Allocated for Marketing and Incentivisation
        totalAllocated += incentivisationAllocation;                              // Add to total Allocated funds
    }