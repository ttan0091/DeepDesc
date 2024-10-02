function getLpTokenPriceUsdc(address tokenAddress)
    public
    view
    returns (uint256)
{
    Pair pair = Pair(tokenAddress);
    uint256 totalLiquidity = getLpTokenTotalLiquidityUsdc(tokenAddress);
    uint256 totalSupply = pair.totalSupply();
    uint8 pairDecimals = pair.decimals();
    uint256 pricePerLpTokenUsdc = (totalLiquidity * 10**pairDecimals) / totalSupply;
    return pricePerLpTokenUsdc;
}