```solidity
function getRedemptionAmounts(
    uint256 principalAmount,
    uint256 yieldAmount,
    uint256 currentRate
)
    private
    view
    returns (
        uint256 redeemableYieldTokens,
        uint256 redeemableBackingTokens,
        uint256 redeemFeeAmount,
        uint256 interestRate
    )
{
    interestRate = effectiveRate(currentRate);
    if (interestRate < initialInterestRate) {
        redeemableBackingTokens = (principalAmount * interestRate) / initialInterestRate;
    } else {
        uint256 rateDiff = interestRate - initialInterestRate;
        // this is expressed in percent with exchangeRate precision
        uint256 yieldPercent = rateDiff.divfV(initialInterestRate, exchangeRateONE);
        uint256 redeemAmountFromYieldShares = yieldAmount.mulfV(yieldPercent, exchangeRateONE);
        // TODO: Scale based on number of decimals for tokens
        redeemableBackingTokens = principalAmount + redeemAmountFromYieldShares;
        // after maturity, all additional yield is being collected as fee
        if (matured && currentRate > interestRate) {
            uint256 additionalYieldRate = currentRate - interestRate;
            uint256 feeBackingAmount = yieldAmount.mulfV(
                additionalYieldRate.mulfV(initialInterestRate, exchangeRateONE),
                exchangeRateONE
            );
            redeemFeeAmount = numYieldTokensPerAsset(feeBackingAmount, currentRate);
        }
    }
    redeemableYieldTokens = numYieldTokensPerAsset(redeemableBackingTokens, currentRate);
    uint256 redeemFeePercent = matured ? feesConfig.matureRedeemPercent : feesConfig.earlyRedeemPercent;
    if (redeemFeePercent != 0) {
        uint256 regularRedeemFee = redeemableYieldTokens.mulfV(redeemFeePercent, yieldBearingONE);
        redeemableYieldTokens -= regularRedeemFee;
        redeemFeeAmount += regularRedeemFee;
        redeemableBackingTokens = numAssetsPerYieldToken(redeemableYieldTokens, currentRate);
    }
}
```