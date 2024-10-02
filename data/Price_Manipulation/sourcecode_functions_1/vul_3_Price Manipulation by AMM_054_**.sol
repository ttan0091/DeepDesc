function ibbtcToCurveLP(uint poolId, uint bBtc) public view returns (uint lp, uint fee) {
    uint sett;
    uint max;
    (sett, fee, max) = settPeak.calcRedeem(poolId, bBtc);
    Pool memory pool = pools[poolId];
    if (bBtc > max) {
        return (0, fee);
    } else {
        // pessimistically charge 0.5% on the withdrawal.
        // Actual fee might be lesser if the vault keeps a buffer
        uint strategyFee = sett.mul(controller.strategies(pool.lpToken).withdrawalFee()).div(10000);
        lp = sett.sub(strategyFee).mul(pool.sett.getPricePerFullShare()).div(1e18);
        fee = fee.add(strategyFee);
    }
}