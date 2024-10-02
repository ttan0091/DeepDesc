function _swapForWeth(address token_) internal returns (uint256 amountOut) {
    if (token_ == address(_WETH)) return _WETH.balanceOf(address(this));
    
    // Handling ETH -> WETH
    if (token_ == address(0)) {
        uint256 ethBalance_ = address(this).balance;
        if (ethBalance_ == 0) return 0;
        _WETH.deposit{value: ethBalance_}();
        return ethBalance_;
    }

    // Handling Curve Pool swaps
    ICurveSwapEth curvePool_ = curvePools[token_];
    if (address(curvePool_) != address(0)) {
        uint256 amount_ = IERC20(token_).balanceOf(address(this));
        if (amount_ == 0) return 0;
        _approve(token_, address(curvePool_));
        (uint256 wethIndex_, uint256 tokenIndex_) = _getIndices(curvePool_, token_);
        curvePool_.exchange(
            tokenIndex_,
            wethIndex_,
            amount_,
            _minWethAmountOut(amount_, token_)
        );
        return _WETH.balanceOf(address(this));
    }

    // Handling ERC20 -> WETH
    return _swap(token_, address(_WETH), IERC20(token_).balanceOf(address(this)));
}