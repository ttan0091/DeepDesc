function getUSDBalanceFromUnderlyingBalance(uint256 _bal)
    public
    view
    returns (uint256 _amount)
{
    if(_bal > 0) {
        address _token0 = IUniswapV2Pair(underlying).token0();
        address _token1 = IUniswapV2Pair(underlying).token1();

        (uint256 _reserves0, uint256 _reserves1, ) = IUniswapV2Pair(underlying).getReserves();
        uint256 _totalSupply = IERC20(underlying).totalSupply();

        uint256 _amount0 = _reserves0.mul(_bal).div(_totalSupply);
        uint256 _amount1 = _reserves1.mul(_bal).div(_totalSupply);

        uint256 _vaultDecimals = ERC20(vault).decimals();
        uint256 _vaultUnit = uint256(10)**uint256(_vaultDecimals);
        uint256 _token0Unit = uint256(10)**uint256(ERC20(_token0).decimals());
        uint256 _token1Unit = uint256(10)**uint256(ERC20(_token1).decimals());

        _amount = _amount0.mul(_vaultUnit).div(_token0Unit) + _amount1.mul(_vaultUnit).div(_token1Unit);
    }
}