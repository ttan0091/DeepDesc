function _executeRemoveLiquiditySingleAsset(ActionInfo memory _actionInfo) internal {
    (
        address targetAmm,
        uint256 callValue,
        bytes memory methodData
    ) = _actionInfo.ammAdapter.getRemoveLiquiditySingleAssetCalldata(
        address(_actionInfo.setToken),
        _actionInfo.liquidityToken,
        _actionInfo.components[0],
        _actionInfo.totalNotionalComponents[0],
        _actionInfo.liquidityQuantity
    );

    _actionInfo.setToken.invokeApprove(
        _actionInfo.liquidityToken,
        _actionInfo.ammAdapter.getSpenderAddress(_actionInfo.liquidityToken),
        _actionInfo.liquidityQuantity
    );

    _actionInfo.setToken.invoke(targetAmm, callValue, methodData);
}