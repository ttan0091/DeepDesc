function redeemZcToken(address u, uint256 m, address t, uint256 a) external onlySwivel(swivel) returns (uint256) {
    Market memory mkt = markets[u][m];
    bool matured = mature[u][m];

    if (!matured) {
        require(matureMarket(u, m), 'failed to mature the market');
    }

    // burn user's zcTokens
    require(ZcToken(mkt.zcTokenAddr).burn(t, a), 'could not burn');

    emit RedeemZcToken(u, m, t, a);

    if (!matured) {
        return a;
    } else {
        // if the market was already mature the return should include the amount + marginal floating interest
        return calculateReturn(u, m, a);
    }
}