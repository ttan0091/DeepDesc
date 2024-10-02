function calculateLiquidityTokenFees(
    uint256 _totalSupplyOfLiquidityTokens,
    InternalBalances memory _internalBalances
) public pure returns (uint256 liquidityTokenFeeQty) {
    uint256 rootK = sqrt(
        _internalBalances.baseTokenReserveQty *
            _internalBalances.quoteTokenReserveQty
    );
    uint256 rootKLast = sqrt(_internalBalances.kLast);
    if (rootK > rootKLast) {
        uint256 numerator = _totalSupplyOfLiquidityTokens * (rootK - rootKLast);
        uint256 denominator = (rootK * 5) + rootKLast;
        liquidityTokenFeeQty = numerator / denominator;
    }
}