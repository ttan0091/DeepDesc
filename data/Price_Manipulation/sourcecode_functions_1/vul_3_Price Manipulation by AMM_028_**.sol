function _peek(bytes6 base, bytes6 quote) private view returns (uint price, uint updateTime) {
    uint256 rawPrice;
    Source memory source = sources[base][quote];
    require(source.source != address(0), "Source not found");

    rawPrice = CTokenInterface(source.source).exchangeRateStored();
    require(rawPrice > 0, "Compound price is zero");

    if (source.inverse) {
        price = 10 ** (source.decimals + 18) / uint(rawPrice);
    } else {
        price = uint(rawPrice) * 10 ** (18 - source.decimals);
    }

    updateTime = block.timestamp; // We should get the timestamp
}