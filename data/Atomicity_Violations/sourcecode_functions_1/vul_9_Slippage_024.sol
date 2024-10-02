function removeLiquidityETHWithPermit(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
) external virtual override returns (uint256 amountToken, uint256 amountETH) {
    address pair = UniswapV2Library.pairFor(factory, token, WETH);
    uint256 value = approveMax ? type(uint256).max : liquidity;
    IUniswapV2Pair(pair).permit(
        msg.sender,
        address(this),
        value,
        deadline,
        v,
        r,
        s
    );
    (amountToken, amountETH) = removeLiquidityETH(
        token,
        liquidity,
        amountTokenMin,
        amountETHMin,
        to,
        deadline
    );
}