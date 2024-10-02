function calcMintWithRen(uint amount) public view returns (uint poolId, uint idx, uint bBTC, uint fee) {
    uint _ibbtc;
    uint _fee;

    // poolId=0, idx=0
    (bBTC, fee) = curveLPToIbbtc(0, pools[0].deposit.calc_token_amount([amount, 0], true));
}