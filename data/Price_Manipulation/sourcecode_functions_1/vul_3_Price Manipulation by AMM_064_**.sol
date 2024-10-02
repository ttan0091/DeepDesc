function liquidateForLender(
    address _lender,
    bool _fromSavingsAccount,
    bool _toSavingsAccount,
    bool _receiveLiquidityShare
) external payable nonReentrant {
    _canLenderBeLiquidated(_lender);

    address _poolSavingsStrategy = poolConstants.poolSavingsStrategy;
    (uint256 _lenderCollateralLPShare, uint256 _lenderBalance) = _updateLenderSharesDuringLiquidation(_lender);

    uint256 _lenderCollateralTokens = _lenderCollateralLPShare;
    _lenderCollateralTokens = IYield(_poolSavingsStrategy).getTokensForShares(_lenderCollateralLPShare);

    _liquidateForLender(_fromSavingsAccount, _lender, _lenderCollateralTokens);

    uint256 _amountReceived = _withdraw(
        _toSavingsAccount,
        _receiveLiquidityShare,
        poolConstants.collateralAsset,
        _poolSavingsStrategy,
        _lenderCollateralTokens
    );
    
    _burn(_lender, _lenderBalance);
    delete lenders[_lender];
    
    emit LenderLiquidated(msg.sender, _lender, _amountReceived);
}