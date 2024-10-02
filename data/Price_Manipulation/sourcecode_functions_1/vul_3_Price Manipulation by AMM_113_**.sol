function _getUniswapPrice(
    IPriceOracle _priceOracle,
    address _poolAddress,
    address _masterQuoteAsset
)
    internal
    view
    returns (uint256)
{
    PoolSettings memory poolInfo = uniswapPoolsToSettings[_poolAddress];
    IUniswapV2Pair poolToken = IUniswapV2Pair(_poolAddress);

    // Get prices against master quote asset. Note: if prices do not exist, function will revert
    uint256 tokenOnePriceToMaster = _priceOracle.getPrice(poolInfo.tokenOne, _masterQuoteAsset);
    uint256 tokenTwoPriceToMaster = _priceOracle.getPrice(poolInfo.tokenTwo, _masterQuoteAsset);

    // Get reserve amounts
    (
        uint256 tokenOneReserves,
        uint256 tokenTwoReserves
    ) = UniswapV2Library.getReserves(uniswapFactory, poolInfo.tokenOne, poolInfo.tokenTwo);

    uint256 normalizedTokenOneBaseUnit = tokenOneReserves.preciseDiv(poolInfo.tokenOneBaseUnit);
    uint256 normalizedTokenBaseTwoUnits = tokenTwoReserves.preciseDiv(poolInfo.tokenTwoBaseUnit);

    uint256 totalNotionalToMaster = normalizedTokenOneBaseUnit.preciseMul(tokenOnePriceToMaster).add(
        normalizedTokenBaseTwoUnits.preciseMul(tokenTwoPriceToMaster)
    );
    uint256 totalSupply = poolToken.totalSupply();

    return totalNotionalToMaster.preciseDiv(totalSupply);
}