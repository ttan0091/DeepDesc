function curveLPToIbbtc(uint poolId, uint _lp) public view returns (uint bBTC, uint fee) {
    Pool memory pool = pools[poolId];
    uint _sett = _lp.mul(1e18).div(pool.sett.getPricePerFullShare());
    return settPeak.calcMint(poolId, _sett);
}