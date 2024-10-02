function _updateLenderSharesDuringLiquidation(address _lender)
    internal
    returns (uint256 _lenderCollateralLPShare, uint256 _lenderBalance)
{
    uint256 _poolBaseLPShares = poolVariables.baseLiquidityShares;
    _lenderBalance = balanceOf(_lender);

    uint256 _lenderBaseLPShares = (_poolBaseLPShares.mul(_lenderBalance)).div(totalSupply());
    uint256 _lenderExtraLPShares = lenders[_lender].extraLiquidityShares;
    poolVariables.baseLiquidityShares = _poolBaseLPShares.sub(_lenderBaseLPShares);
    poolVariables.extraLiquidityShares = poolVariables.extraLiquidityShares.sub(_lenderExtraLPShares);

    _lenderCollateralLPShare = _lenderBaseLPShares.add(_lenderExtraLPShares);
}