function _getTokenRatesStored() private view returns (uint256[] memory) {
    uint256[] memory rates = new uint256[](_TOTAL_TOKENS);
    rates[0] = _token0.getPricePerFullShareStored();
    rates[1] = _token1.getPricePerFullShareStored();
    return rates;
}
