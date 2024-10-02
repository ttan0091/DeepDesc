function profitOf(address minter, address flip, uint amount) 
    external 
    view 
    returns (uint _usd, uint _hunny, uint _bnb) 
{
    _usd = tvl(flip, amount);
    
    if (address(minter) == address(0)) {
        _hunny = 0;
    } else {
        uint performanceFee = IHunnyMinter(minter).performanceFee(_usd);
        _usd = _usd.sub(performanceFee);
        uint bnbAmount = performanceFee.mul(1e18).div(bnbPriceInUSD());
        _hunny = IHunnyMinter(minter).amountHunnyToMint(bnbAmount);
    }
    
    _bnb = 0;
}