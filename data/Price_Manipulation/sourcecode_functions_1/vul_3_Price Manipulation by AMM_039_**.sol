function getExpectedReturnGivenIn(uint256 amount, bool yieldShareIn) public view returns (uint256) {
    (, uint256[] memory balances, ) = getVault().getPoolTokens(getPoolId());
    (uint256 currentAmp, ) = _getAmplificationParameter();
    (IPoolShare tokenIn, IPoolShare tokenOut) = yieldShareIn
        ? (tempusPool.yieldShare(), tempusPool.principalShare())
        : (tempusPool.principalShare(), tempusPool.yieldShare());
    (uint256 indexIn, uint256 indexOut) = address(tokenIn) == address(_token0) ? (0, 1) : (1, 0);

    amount = _subtractSwapFeeAmount(amount);
    balances.mul(_getTokenRatesStored(), _TEMPUS_SHARE_PRECISION);
    uint256 rateAdjustedSwapAmount = (amount * tokenIn.getPricePerFullShareStored()) / _TEMPUS_SHARE_PRECISION;

    uint256 amountOut = StableMath._calcOutGivenIn(currentAmp, balances, indexIn, indexOut, rateAdjustedSwapAmount);
    amountOut = (amountOut * _TEMPUS_SHARE_PRECISION) / tokenOut.getPricePerFullShareStored();

    return amountOut;
}