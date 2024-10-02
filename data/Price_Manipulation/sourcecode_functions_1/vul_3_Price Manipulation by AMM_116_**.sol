function _minTokenAmountOut(uint256 wethAmount_, address token_) 
    internal 
    view 
    returns (uint256 minAmountOut) 
{
    uint256 priceInEth_ = _getPriceInEth(token_);
    if (priceInEth_ == 0) return 0;
    
    return wethAmount_
        .scaledDiv(priceInEth_)
        .scaledMul(slippageTolerance)
        .scaleTo(IERC20Full(token_).decimals());
}