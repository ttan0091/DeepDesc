function calcRedeem(uint poolId, uint bBtc)
    override
    external
    view
    returns (uint sett, uint fee, uint max)
{
    CurvePool memory pool = pools[poolId];
    uint btc;
    (btc, fee) = core.bBtcToBtc(bBtc);
    sett = _btcToSett(pool, btc);
    max = pool.sett.balanceOf(address(this))
        .mul(pool.sett.getPricePerFullShare())
        .mul(pool.swap.get_virtual_price())
        .div(core.pricePerShare())
        .div(1e18);
}