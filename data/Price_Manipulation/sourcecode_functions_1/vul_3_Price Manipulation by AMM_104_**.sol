function calculateSetTokenValuation(ISetToken _setToken, address _quoteAsset) external view returns (uint256) {
    IPriceOracle priceOracle = controller.getPriceOracle();
    address masterQuoteAsset = priceOracle.masterQuoteAsset();
    address[] memory components = _setToken.getComponents();
    int256 valuation;

    for (uint256 i = 0; i < components.length; i++) {
        address component = components[i];
        // Get component price from price oracle. If price does not exist, revert.
        uint256 componentPrice = priceOracle.getPrice(component, masterQuoteAsset);
        int256 aggregateUnits = _setToken.getTotalComponentRealUnits(component);
        // Normalize each position unit to preciseUnits 1e18 and cast to signed int
        uint256 unitDecimals = ERC20(component).decimals();
        uint256 baseUnits = 10 ** unitDecimals;
        int256 normalizedUnits = aggregateUnits.preciseDiv(baseUnits.toInt256());
        // Calculate valuation of the component. Debt positions are effectively subtracted
        valuation = normalizedUnits.preciseMul(componentPrice.toInt256()).add(valuation);
    }

    if (masterQuoteAsset != _quoteAsset) {
        uint256 quoteToMaster = priceOracle.getPrice(_quoteAsset, masterQuoteAsset);
        valuation = valuation.preciseDiv(quoteToMaster.toInt256());
    }

    return valuation.toUint256();
}