function pricePerPrincipalShare(uint256 currYield, uint256 estYield) private view returns (uint256) {
    // in case we have estimate for negative yield
    if (estYield < exchangeRateONE) {
        return interestRateToSharePrice(currYield);
    }
    uint256 principalPrice = currYield.divfV(estYield, exchangeRateONE);
    return interestRateToSharePrice(principalPrice);
}