```solidity
function _redeemFresh(
    address payable redeemer,
    uint256 redeemTokensIn,
    uint256 redeemAmountIn
) internal {
    require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");

    IAssetManager assetManagerContract = IAssetManager(assetManager);
    uint256 exchangeRate = exchangeRateStored();
    uint256 redeemTokens;
    uint256 redeemAmount;

    if (redeemTokensIn > 0) {
        /*
         * We calculate the exchange rate and the amount of underlying to be redeemed:
         *  redeemTokens = redeemTokensIn
         *  redeemAmount = redeemTokensIn x exchangeRateCurrent
         */
        redeemTokens = redeemTokensIn;
        redeemAmount = (redeemTokensIn * exchangeRate) / WAD;
    } else {
        /*
         * We get the current exchange rate and calculate the amount to be redeemed:
         *  redeemTokens = redeemAmountIn / exchangeRate
         *  redeemAmount = redeemAmountIn
         */
        redeemTokens = (redeemAmountIn * WAD) / exchangeRate;
        redeemAmount = redeemAmountIn;
    }

    require(totalRedeemable >= redeemAmount, "redeem amount error");
    totalRedeemable -= redeemAmount;
    uErc20.burn(redeemer, redeemTokens);
    require(assetManagerContract.withdraw(underlying, redeemer, redeemAmount), "UToken: Failed to withdraw");

    emit LogRedeem(redeemer, redeemTokensIn, redeemAmountIn, redeemAmount);
}
```