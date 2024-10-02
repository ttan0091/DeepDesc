function _minWethAmountOut(uint256 tokenAmount_, address token_)
    internal
    view
    returns (uint256 minAmountOut)
{
    uint256 priceInEth_ = _getPriceInEth(token_);
    if (priceInEth_ == 0) return 0;
    
    return tokenAmount_
        .scaledMul(priceInEth_)
        .scaledMul(slippageTolerance)
        .scaleFrom(IERC20Full(token_).decimals());
}