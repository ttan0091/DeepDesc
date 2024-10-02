function getExpectedLPTokensForTokensIn(uint256[] memory amountsIn) external view returns (uint256) {
    (, uint256[] memory balances, ) = getVault().getPoolTokens(getPoolId());

    uint256[] memory tokenRates = _getTokenRatesStored();
    balances.mul(tokenRates, _TEMPUS_SHARE_PRECISION);
    amountsIn.mul(tokenRates, _TEMPUS_SHARE_PRECISION);

    (uint256 currentAmp, ) = _getAmplificationParameter();

    return (balances[0] == 0)
        ? StableMath._calculateInvariant(currentAmp, amountsIn, true)
        : StableMath._calcBptOutGivenExactTokensIn(
            currentAmp,
            balances,
            amountsIn,
            totalSupply(),
            getSwapFeePercentage()
        );
}