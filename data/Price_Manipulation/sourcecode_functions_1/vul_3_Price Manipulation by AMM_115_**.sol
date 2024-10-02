function swap(
    address fromToken_,
    address toToken_,
    uint256 amountIn_
) public payable override returns (uint256 amountOut) {
    // Validating ETH value sent
    require(msg.value == (fromToken_ == address(0) ? amountIn_ : 0), Error.INVALID_AMOUNT); 
    if (amountIn_ == 0) {
        emit Swapped(fromToken_, toToken_, 0, 0);
        return 0; 
    }
    
    // Handling swap between the same token
    if (fromToken_ == toToken_) {
        if (fromToken_ == address(0)) {
            payable(msg.sender).transfer(amountIn_);
        }
        emit Swapped(fromToken_, toToken_, amountIn_, amountIn_);
        return amountIn_;
    }
    
    // Transferring to contract if ERC20
    if (fromToken_ != address(0)) {
        IERC20(fromToken_).safeTransferFrom(msg.sender, address(this), amountIn_);
    }
    
    // Swapping token via WETH
    uint256 amountOut_ = _swapWethForToken(toToken_, _swapForWeth(fromToken_));
    emit Swapped(fromToken_, toToken_, amountIn_, amountOut_);
    return _returnTokens(toToken_, amountOut_);
}