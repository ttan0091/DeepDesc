function trackMaltPrice()
    external
    onlyRole(UPDATER_ROLE, "Must have updater role")
{
    (uint256 reserve0, uint256 reserve1, ) = stakeToken.getReserves();
    (address token0, ) = UniswapV2Library.sortTokens(address(malt), address(rewardToken));
    uint256 rewardDecimals = rewardToken.decimals();
    uint256 price;

    if (token0 == address(rewardToken)) {
        price = _normalizedPrice(reserve0, reserve1, rewardDecimals);
    } else {
        price = _normalizedPrice(reserve1, reserve0, rewardDecimals);
    }
    
    maltPriceMA.update(price);
    emit TrackMaltPrice(price);
}