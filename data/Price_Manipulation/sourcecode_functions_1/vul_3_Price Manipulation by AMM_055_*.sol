function calcRedeemInRen(uint amount) public view returns (uint poolId, uint idx, uint renAmount, uint fee) {
    uint _lp;
    uint _fee;
    uint _ren;

    // poolId=0, idx=0
    (_lp, fee) = ibbtcToCurveLP(0, amount);
    renAmount = pools[0].deposit.calc_withdraw_one_coin(_lp, 0);
}