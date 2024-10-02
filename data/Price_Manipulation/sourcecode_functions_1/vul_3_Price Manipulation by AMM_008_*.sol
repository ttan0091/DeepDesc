function _apy(uint pid) 
    view 
    private 
    returns (uint) 
{
    (address token,,,) = master.poolInfo(pid);
    uint poolSize = tvl(token, IBEP20(token).balanceOf(address(master))).mul(1e18).div(bnbPriceInUSD());
    return cakePriceInBNB().mul(cakePerYearOfPool(pid)).div(poolSize);
}