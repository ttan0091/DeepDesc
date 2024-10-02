function calcWithdrawAmounts(uint dToken, uint idx) external view returns (uint quoteAsset, uint baseAsset) {
    IAMM amm = clearingHouse.amms(idx);
    IVAMM vamm = amm.vamm();

    uint totalDTokenSupply = vamm.totalSupply();
    if (totalDTokenSupply > 0) {
        quoteAsset = (vamm.balances(0) * dToken) / totalDTokenSupply;
        baseAsset = (vamm.balances(1) * dToken) / totalDTokenSupply;
    }
}