function getPrice(address _assetOne, address _assetTwo) external view returns (uint256) {
    require(
        controller.isSystemContract(msg.sender),
        "PriceOracle.getPrice: Caller must be system contract."
    );

    bool priceFound;
    uint256 price;

    (priceFound, price) = _getDirectOrInversePrice(_assetOne, _assetTwo);

    if (!priceFound) {
        (priceFound, price) = _getPriceFromMasterQuote(_assetOne, _assetTwo);
    }

    if (!priceFound) {
        (priceFound, price) = _getPriceFromAdapters(_assetOne, _assetTwo);
    }

    require(priceFound, "PriceOracle.getPrice: Price not found.");

    return price;
}