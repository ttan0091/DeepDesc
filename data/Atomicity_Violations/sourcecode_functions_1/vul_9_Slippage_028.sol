function removeLiquidity(
    ISetToken _setToken,
    string memory _ammName,
    address _ammPool,
    uint256 _poolTokenPositionUnits,
    address[] calldata _components,
    uint256[] calldata _minComponentUnitsReceived
)
    external
    nonReentrant
    onlyManagerAndValidSet(_setToken)
{
    ActionInfo memory actionInfo = _getActionInfo(
        _setToken,
        _ammName,
        _ammPool,
        _components,
        _minComponentUnitsReceived,
        _poolTokenPositionUnits
    );

    _validateRemoveLiquidity(actionInfo);

    _executeRemoveLiquidity(actionInfo);

    _validateMinimumUnderlyingReceived(actionInfo);

    int256 liquidityTokenDelta = _updateLiquidityTokenPositions(actionInfo);

    int256[] memory componentsDelta = _updateComponentPositions(actionInfo);

    emit LiquidityRemoved(
        _setToken,
        _ammPool,
        liquidityTokenDelta,
        _components,
        componentsDelta
    );
}