function _executeTrade(
    ActionInfo memory _actionInfo,
    IERC20 _sendToken,
    IERC20 _receiveToken,
    bytes memory _data
)
    internal
    returns (uint256)
{
    ISetToken setToken = _actionInfo.setToken;
    uint256 notionalSendQuantity = _actionInfo.notionalSendQuantity;

    setToken.invokeApprove(
        address(_sendToken),
        _actionInfo.exchangeAdapter.getSpender(),
        notionalSendQuantity
    );

    (
        address targetExchange,
        uint256 callValue,
        bytes memory methodData
    ) = _actionInfo.exchangeAdapter.getTradeCalldata(
        address(_sendToken),
        address(_receiveToken),
        address(setToken),
        notionalSendQuantity,
        _actionInfo.minNotionalReceiveQuantity,
        _data
    );

    setToken.invoke(targetExchange, callValue, methodData);

    uint256 receiveTokenQuantity = _receiveToken.balanceOf(address(setToken)).sub(_actionInfo.preTradeReceiveTokenBalance);
    require(
        receiveTokenQuantity >= _actionInfo.minNotionalReceiveQuantity,
        "Slippage too high"
    );

    return receiveTokenQuantity;
}