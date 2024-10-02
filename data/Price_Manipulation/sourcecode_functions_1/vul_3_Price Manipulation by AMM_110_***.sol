function deleverToZeroBorrowBalance(
    ISetToken _setToken,
    IERC20 _collateralAsset,
    IERC20 _repayAsset,
    uint256 _redeemQuantity,
    string memory _tradeAdapterName,
    bytes memory _tradeData
)
    external
    nonReentrant
    onlyManagerAndValidSet(_setToken)
{
    uint256 notionalRedeemQuantity = _redeemQuantity.preciseMul(_setToken.totalSupply());

    require(borrowCTokenEnabled[_setToken][underlyingToCToken[_repayAsset]], "Borrow not enabled");
    uint256 notionalRepayQuantity = underlyingToCToken[_repayAsset].borrowBalanceCurrent(address(_setToken));

    ActionInfo memory deleverInfo = _createAndValidateActionInfoNotional(
        _setToken,
        _collateralAsset,
        _repayAsset,
        notionalRedeemQuantity,
        notionalRepayQuantity,
        _tradeAdapterName,
        false
    );

    _redeemUnderlying(deleverInfo.setToken, deleverInfo.collateralCTokenAsset, deleverInfo.notionalSendQuantity);

    _executeTrade(deleverInfo, _collateralAsset, _repayAsset, _tradeData);

    // We use notionalRepayQuantity vs. Compound's max value uint256(-1) to handle WETH properly
    _repayBorrow(deleverInfo.setToken, deleverInfo.borrowCTokenAsset, _repayAsset, notionalRepayQuantity);

    // Update default position first to save gas on editing borrow position
    _setToken.calculateAndEditDefaultPosition(
        address(_repayAsset),
        deleverInfo.setTotalSupply,
        deleverInfo.preTradeReceiveTokenBalance
    );

    _updateLeverPositions(deleverInfo, _repayAsset);

    emit LeverageDecreased(
        _setToken,
        _collateralAsset,
        _repayAsset,
        deleverInfo.exchangeAdapter,
        deleverInfo.notionalSendQuantity,
        notionalRepayQuantity,
        0 // No protocol fee
    );
}