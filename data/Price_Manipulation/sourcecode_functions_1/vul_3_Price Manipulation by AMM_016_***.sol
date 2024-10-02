function withdrawToVault(uint256 _usdAmount, address _asset)
    external
    restricted
{
    address _token0 = IUniswapV2Pair(underlying).token0();
    address _token1 = IUniswapV2Pair(underlying).token1();
    uint256 _usdBalance = getUSDBalanceFromUnderlyingBalance(underlyingBalance());

    if (_usdBalance == 0) {
        return;
    }

    uint256 _defaultUnit = uint256(10)**uint256(18);
    uint256 _assetUnit = uint256(10)**uint256(ERC20(_asset).decimals());

    uint256 _underlyingBal = IERC20(underlying).balanceOf(address(this));
    uint256 _amount = underlyingBalance().mul(_usdAmount).div(_usdBalance);

    if (_amount < _underlyingBal) {
        uint256 _toWithdraw = _amount.mul(_assetUnit).div(_defaultUnit);

        IERC20(_asset).safeTransferFrom(address(this), vault, _toWithdraw);

        return;
    }

    uint256 _missing = _amount.sub(_underlyingBal);
    if (_missing > rewardPoolUnderlyingBalance()) {
        _missing = rewardPoolUnderlyingBalance();
    }

    IMasterChef(masterChef).withdraw(poolId, _missing);

    _assetFromUnderlying(
        _asset,
        _missing,
        toVaultAssetRoutes[_asset][_token0],
        toVaultAssetRoutes[_asset][_token1]
    );

    IERC20(_asset).safeTransfer(
        vault,
        IERC20(_asset).balanceOf(address(this))
    );
}