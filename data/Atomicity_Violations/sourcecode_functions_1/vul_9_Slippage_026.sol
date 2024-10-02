function _liquidateMaker(address maker) internal {
    require(
        _calcMarginFraction(maker, false) < maintenanceMargin,
        "CH: Above Maintenance Margin"
    );
    
    int256 realizedPnl;
    uint quoteAsset;

    for (uint i = 0; i < amms.length; i++) {
        (,, uint dToken,,,,) = amms[i].makers(maker);
        // @todo put checks on slippage
        (int256 _realizedPnl, uint _quote) = amms[i].removeLiquidity(maker, dToken, 0, 0);
        realizedPnl += _realizedPnl;
        quoteAsset += _quote;
    }

    _disperseLiquidationFee(
        maker,
        realizedPnl,
        2 * quoteAsset, // total liquidity value = 2 * quote value
        true // isLiquidation
    );

    _chargeFeeAndRealizePnL(maker, realizedPnl);
}