function tvl() 
    override 
    public 
    view 
    returns (uint) 
{
    uint stakingTVL = helper.tvl(address(stakingToken), _totalSupply);

    uint price = rewardsToken.priceShare();
    uint earned = rewardsToken.balanceOf(address(this)).mul(price).div(1e18);
    uint rewardTVL = helper.tvl(CAKE, earned);

    return stakingTVL.add(rewardTVL);
}