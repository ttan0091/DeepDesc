function _assetFromUnderlying(
    address _asset,
    uint256 _liquidity,
    address[] memory _route0,
    address[] memory _route1
) 
    internal 
{
    address _token0 = IUniswapV2Pair(underlying).token0();
    address _token1 = IUniswapV2Pair(underlying).token1();

    IUniswapV2Router02(router).removeLiquidity(
        _token0,
        _token1,
        _liquidity,
        1, // we are willing to take whatever the pair gives us
        1, // we are willing to take whatever the pair gives us
        address(this),
        block.timestamp
    );

    uint256 _token0Amount = IERC20(_token0).balanceOf(address(this));
    uint256 _token1Amount = IERC20(_token1).balanceOf(address(this));

    if (_route0.length > 1) {
        _swapSushiswapWithPath(_route0, _token0Amount);
    }

    if (_route1.length > 1) {
        _swapSushiswapWithPath(_route1, _token1Amount);
    }
}