function removeLiquidity(
    MarketParameters memory marketState,
    int256 tokensToRemove
)
    public
    pure
    returns (
        MarketParameters memory,
        int256,
        int256
    )
{
    (int256 assetCash, int256 fCash) = marketState.removeLiquidity(tokensToRemove);

    assert(assetCash >= 0);
    assert(fCash >= 0);
    return (marketState, assetCash, fCash);
}