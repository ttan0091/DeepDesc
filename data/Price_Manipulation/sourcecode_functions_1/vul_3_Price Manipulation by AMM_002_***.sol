function valueOfAsset(address asset, uint amount) 
    public 
    view 
    override 
    returns (uint valueInBNB, uint valueInUSD) 
{
    if (asset == address(0) || asset == WBNB) {
        valueInBNB = amount;
        valueInUSD = amount.mul(priceOfBNB()).div(1e18);
    } 
    else if (keccak256(abi.encodePacked(IPancakePair(asset).symbol())) == keccak256("Cake-LP")) {
        if (IPancakePair(asset).totalSupply() == 0) return (0, 0);

        if (IPancakePair(asset).token0() == WBNB || IPancakePair(asset).token1() == WBNB) {
            valueInBNB = amount.mul(IBEP20(WBNB).balanceOf(address(asset))).mul(2).div(IPancakePair(asset).totalSupply());
            valueInUSD = valueInBNB.mul(priceOfBNB()).div(1e18);
        } 
        else {
            uint balanceToken0 = IBEP20(IPancakePair(asset).token0()).balanceOf(asset);
            (uint token0PriceInBNB, ) = valueOfAsset(IPancakePair(asset).token0(), 1e18);

            valueInBNB = amount.mul(balanceToken0).mul(2).mul(token0PriceInBNB).div(1e18).div(IPancakePair(asset).totalSupply());
            valueInUSD = valueInBNB.mul(priceOfBNB()).div(1e18);
        }
    } 
    else {
        address pairToken = pairTokens[asset] == address(0) ? WBNB : pairTokens[asset];
        address pair = factory.getPair(asset, pairToken);
        if (IBEP20(asset).balanceOf(pair) == 0) return (0, 0);

        valueInBNB = IBEP20(pairToken).balanceOf(pair).mul(amount).div(IBEP20(asset).balanceOf(pair));
        if (pairToken != WBNB) {
            (uint pairValueInBNB, ) = valueOfAsset(pairToken, 1e18);
            valueInBNB = valueInBNB.mul(pairValueInBNB).div(1e18);
        }
        valueInUSD = valueInBNB.mul(priceOfBNB()).div(1e18);
    }
}