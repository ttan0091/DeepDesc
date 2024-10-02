function pricePerYieldShare(uint256 currYield, uint256 estYield) private view returns (uint256) {
    uint one = exchangeRateONE;
    // in case we have estimate for negative yield
    if (estYield < one) {
        return uint256(0);
    }
    uint256 yieldPrice = (estYield - one).mulfV(currYield, one).divfV(estYield, one);
    return interestRateToSharePrice(yieldPrice);
}