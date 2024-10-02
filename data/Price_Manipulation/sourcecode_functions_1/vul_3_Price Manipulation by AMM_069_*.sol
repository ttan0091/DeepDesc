function investedAssets() external view override(BaseStrategy) returns (uint256) {
    uint256 underlyingBalance = _getUnderlyingBalance();
    uint256 aUstBalance = _getAUstBalance() + pendingRedeems;

    uint256 ustAssets = ((exchangeRateFeeder.exchangeRateOf(
        address(aUstToken),
        true
    ) * aUstBalance) / 1e18) + pendingDeposits;

    return underlyingBalance + curvePool.get_dy_underlying(ustI, underlyingI, ustAssets);
}