function apy() 
    override 
    public 
    view 
    returns (uint _usd, uint _hunny, uint _bnb) 
{
    uint tokenDecimals = 1e18;
    uint __totalSupply = _totalSupply;
    if (__totalSupply == 0) {
        __totalSupply = tokenDecimals;
    }

    uint rewardPerTokenPerSecond = rewardRate.mul(tokenDecimals).div(__totalSupply);
    uint hunnyPrice = helper.tokenPriceInBNB(address(stakingToken));
    uint flipPrice = helper.tvlInBNB(address(rewardsToken), 1e18);

    _usd = 0;
    _hunny = 0;
    _bnb = rewardPerTokenPerSecond.mul(365 days).mul(flipPrice).div(hunnyPrice);
}