function estimatedYield(uint256 yieldCurrent) private view returns (uint256) {
    if (matured) {
        return yieldCurrent;
    }
    uint256 currentTime = block.timestamp;
    uint256 timeToMaturity = (maturityTime > currentTime) ? (maturityTime - currentTime) : 0;
    uint256 poolDuration = maturityTime - startTime;
    uint256 timeLeft = timeToMaturity.divfV(poolDuration, exchangeRateONE);

    return yieldCurrent + timeLeft.mulfV(initialEstimatedYield, exchangeRateONE);
}