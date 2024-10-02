function _getSetTokenMintQuantity(
    ISetToken _setToken,
    address _reserveAsset,
    uint256 _netReserveFlows,
    uint256 _setTotalSupply
)
    internal
    view
    // Value of reserve asset net of fees
    returns (uint256)
{
    uint256 premiumPercentage = _getIssuePremium(_setToken, _reserveAsset, _netReserveFlows);
    uint256 premiumValue = _netReserveFlows.preciseMul(premiumPercentage);

    // If the set manager provided a custom valuer at initialization time, use it. Otherwise get it from the controller.
    // Get valuation of the SetToken with the quote asset as the reserve asset. Returns value in precise units
    // Reverts if price is not found
    uint256 setTokenValuation = _getSetValuer(_setToken).calculateSetTokenValuation(_setToken, _reserveAsset);

    // Get reserve asset decimals
    uint256 reserveAssetDecimals = ERC20(_reserveAsset).decimals();
    uint256 normalizedTotalReserveQuantityNetFees = _netReserveFlows.preciseDiv(10 ** reserveAssetDecimals);
    uint256 normalizedTotalReserveQuantityNetFeesAndPremium = _netReserveFlows.sub(premiumValue).preciseDiv(10 ** reserveAssetDecimals);

    // Calculate SetTokens to mint to issuer
    uint256 denominator = _setTotalSupply.preciseMul(setTokenValuation).add(normalizedTotalReserveQuantityNetFeesAndPremium);
    return normalizedTotalReserveQuantityNetFeesAndPremium.preciseMul(_setTotalSupply).preciseDiv(denominator);
}