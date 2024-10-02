function getITokenBonusAmount(uint256 _pid, uint256 _amountInToken) public view returns (uint256) {
    PoolInfo storage pool = poolInfo[_pid];
    (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(pool.swapPairAddress).getReserves();
    uint256 amountTokenOut = 0;
    uint256 _fee = 0;
    if (IUniswapV2Pair(pool.swapPairAddress).token0() == address(iToken)) {
        amountTokenOut = getAmountOut(_amountInToken, _reserve0, _reserve1, _fee);
    } else {
        amountTokenOut = getAmountOut(_amountInToken, _reserve1, _reserve0, _fee);
    }
    return amountTokenOut;
}