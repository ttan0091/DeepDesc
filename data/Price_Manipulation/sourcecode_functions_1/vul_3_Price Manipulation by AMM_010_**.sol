function tvl(address _flip, uint amount) 
    public 
    view 
    returns (uint) 
{
    if (_flip == address(CAKE)) {
        return cakePriceInBNB().mul(bnbPriceInUSD()).mul(amount).div(1e36);
    }
    
    address _token0 = IPancakePair(_flip).token0();
    address _token1 = IPancakePair(_flip).token1();
    
    // using hunny price from the oracle
    if (_token0 == address(hunny) || _token1 == address(hunny)) {
        uint hunnyBalance = hunny.balanceOf(address(_flip)).mul(amount).div(IBEP20(_flip).totalSupply());
        uint priceInBNB = tokenPriceInBNB(address(hunny));
        uint price = priceInBNB.mul(bnbPriceInUSD()).div(1e18);
        return hunnyBalance.mul(price).div(1e18).mul(2);
    }
    
    if (_token0 == address(WBNB) || _token1 == address(WBNB)) {
        uint bnb = WBNB.balanceOf(address(_flip)).mul(amount).div(IBEP20(_flip).totalSupply());
        uint price = bnbPriceInUSD();
        return bnb.mul(price).div(1e18).mul(2);
    }
    
    uint balanceToken0 = IBEP20(_token0).balanceOf(_flip);
    uint price = tokenPriceInBNB(_token0);
    return balanceToken0.mul(price).div(1e18).mul(bnbPriceInUSD()).div(1e18).mul(2);
}