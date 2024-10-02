function _swapWethForToken(address token_, uint256 amount_) 
    internal 
    returns (uint256 amountOut) 
{
    if (amount_ == 0) return 0;
    if (token_ == address(_WETH)) return amount_;

    // Handling WETH -> ETH
    if (token_ == address(0)) {
        _WETH.withdraw(amount_);
        return amount_;
    }

    // Handling Curve Pool swaps
    ICurveSwapEth curvePool_ = curvePools[token_];
    if (address(curvePool_) != address(0)) {
        _approve(address(_WETH), address(curvePool_));
        (uint256 wethIndex_, uint256 tokenIndex_) = _getIndices(curvePool_, token_);
        curvePool_.exchange(
            wethIndex_,
            tokenIndex_,
            amount_,
            _minTokenAmountOut(amount_, token_)
        );
        return IERC20(token_).balanceOf(address(this));
    }

    // Handling WETH -> ERC20
    return _swap(address(_WETH), token_, amount_);
}