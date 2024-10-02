function _createIssuanceInfo(
    ISetToken _setToken,
    address _reserveAsset,
    uint256 _reserveAssetQuantity
)
    internal
    view
    returns (ActionInfo memory)
{
    ActionInfo memory issueInfo;

    issueInfo.previousSetTokenSupply = _setToken.totalSupply();
    issueInfo.preFeeReserveQuantity = _reserveAssetQuantity;

    (issueInfo.protocolFees, issueInfo.managerFee, issueInfo.netFlowQuantity) = _getFees(
        _setToken,
        issueInfo.preFeeReserveQuantity,
        PROTOCOL_ISSUE_MANAGER_REVENUE_SHARE_FEE_INDEX,
        PROTOCOL_ISSUE_DIRECT_FEE_INDEX,
        MANAGER_ISSUE_FEE_INDEX
    );

    issueInfo.setTokenQuantity = _getSetTokenMintQuantity(
        _setToken,
        _reserveAsset,
        issueInfo.netFlowQuantity,
        issueInfo.previousSetTokenSupply
    );

    (issueInfo.newSetTokenSupply, issueInfo.newPositionMultiplier) = _getIssuePositionMultiplier(
        _setToken,
        issueInfo.setTokenQuantity
    );

    issueInfo.newReservePositionUnit = _getIssuePositionUnit(_setToken, _reserveAsset, issueInfo);

    return issueInfo;
}