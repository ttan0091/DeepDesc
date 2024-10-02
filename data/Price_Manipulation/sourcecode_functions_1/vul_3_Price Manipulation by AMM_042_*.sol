function calculateReturn(address u, uint256 m, uint256 a) internal returns (uint256) {
    // calculate difference between the cToken exchange rate @ maturity and the current cToken exchange rate
    uint256 yield = ((CErc20(markets[u][m].cTokenAddr).exchangeRateCurrent() * 1e26) / maturityRate[u][m]) - 1e26;
    uint256 interest = (yield * a) / 1e26;

    // calculate the total amount of underlying principal to return
    return a + interest;
}