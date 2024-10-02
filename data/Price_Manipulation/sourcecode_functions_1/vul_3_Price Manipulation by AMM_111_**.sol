function getPrice(address _assetOne, address _assetTwo) external view returns (bool, uint256) {
    require(controller.isSystemContract(msg.sender), "Must be system contract");

    bool isAllowedUniswapPoolOne = uniswapPoolsToSettings[_assetOne].isValid;
    bool isAllowedUniswapPoolTwo = uniswapPoolsToSettings[_assetTwo].isValid;

    // If assetOne and assetTwo are both not Uniswap pools, then return false
    if (!isAllowedUniswapPoolOne && !isAllowedUniswapPoolTwo) {
        return (false, 0);
    }

    IPriceOracle priceOracle = controller.getPriceOracle();
    address masterQuoteAsset = priceOracle.masterQuoteAsset();

    uint256 assetOnePriceToMaster;
    if (isAllowedUniswapPoolOne) {
        assetOnePriceToMaster = _getUniswapPrice(priceOracle, _assetOne, masterQuoteAsset);
    } else {
        assetOnePriceToMaster = priceOracle.getPrice(_assetOne, masterQuoteAsset);
    }

    uint256 assetTwoPriceToMaster;
    if (isAllowedUniswapPoolTwo) {
        assetTwoPriceToMaster = _getUniswapPrice(priceOracle, _assetTwo, masterQuoteAsset);
    } else {
        assetTwoPriceToMaster = priceOracle.getPrice(_assetTwo, masterQuoteAsset);
    }

    return (true, assetOnePriceToMaster.preciseDiv(assetTwoPriceToMaster));
}