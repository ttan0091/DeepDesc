function _peek(bytes6 base, bytes6 kind) private view returns (uint price, uint updateTime) {
    uint256 rawPrice;
    address source = sources[base][kind];
    require(source != address(0), "Source not found");

    if (kind == "rate") {
        rawPrice = CTokenInterface(source).borrowIndex();
    } else if (kind == "chi") {
        rawPrice = CTokenInterface(source).exchangeRateStored();
    } else {
        revert("Unknown oracle type");
    }

    require(rawPrice > 0, "Compound price is zero");

    price = rawPrice * SCALE_FACTOR;
    updateTime = block.timestamp;
}