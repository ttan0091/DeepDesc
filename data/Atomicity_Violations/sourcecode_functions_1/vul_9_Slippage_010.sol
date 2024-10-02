function _withdrawCollateralLiquidityTokens(
    PortfolioState memory portfolioState,
    LiquidationFactors memory factors,
    uint256 blockTime,
    int256 collateralToWithdraw
) internal view returns (int256) {
    require(portfolioState.newAssets.length == 0); // dev: new assets in portfolio
    factors.markets = new MarketParameters[](factors.cashGroup.maxMarketIndex);

    for (uint256 i; i < portfolioState.storedAssets.length; i++) {
        PortfolioAsset memory asset = portfolioState.storedAssets[i];
        if (asset.storageState == AssetStorageState.Delete) continue;
        if (
            !AssetHandler.isLiquidityToken(asset.assetType) ||
            asset.currencyId != factors.cashGroup.currencyId
        ) continue;
        
        uint256 marketIndex = asset.assetType - 1;
        // This is set up this way so that we can delay setting storage of markets so that this method
        // remain a view function
        factors.cashGroup.loadMarket(
            factors.markets[marketIndex - 1],
            marketIndex,
            true,
            blockTime
        );
        (int256 cashClaim, int256 fCashClaim) = asset.getCashClaims(factors.markets[marketIndex - 1]);
        
        if (cashClaim <= collateralToWithdraw) {
            // The additional cash is insufficient to cover asset amount required so we just remove it
            portfolioState.deleteAsset(i);
            factors.markets[marketIndex - 1].removeLiquidity(asset.notional);
            collateralToWithdraw = collateralToWithdraw - cashClaim;
        } else {
            // Otherwise remove a proportional amount of liquidity tokens to cover the amount remaining
            // NOTE: dust can accrue when withdrawing liquidity at this point
            int256 tokensToRemove = asset.notional.mul(collateralToWithdraw).div(cashClaim);
            (cashClaim, fCashClaim) = factors.markets[marketIndex - 1].removeLiquidity(tokensToRemove);
            // Remove liquidity token balance
            portfolioState.storedAssets[i].notional = asset.notional.subNoNeg(tokensToRemove);
            portfolioState.storedAssets[i].storageState = AssetStorageState.Update;
            collateralToWithdraw = 0;
        }
        // Add the net fCash asset to the portfolio since we've withdrawn the liquidity tokens
        portfolioState.addAsset(
            factors.cashGroup.currencyId,
            asset.maturity,
            Constants.FCASH_ASSET_TYPE,
            fCashClaim
        );
        if (collateralToWithdraw == 0) return 0;
    }
    return collateralToWithdraw;
}
```