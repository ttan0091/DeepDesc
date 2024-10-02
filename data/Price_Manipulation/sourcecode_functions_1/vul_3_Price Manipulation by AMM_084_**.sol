function getVotingPower(uint256 sNOTEAmount) public view returns (uint256) {
    // Gets the BPT token price (in ETH)
    uint256 bptPrice = IPriceOracle(address(BALANCER_POOL_TOKEN)).getLatest(IPriceOracle.Variable.BPT);

    // Gets the NOTE token price (in ETH)
    uint256 notePrice = IPriceOracle(address(BALANCER_POOL_TOKEN)).getLatest(IPriceOracle.Variable.NOTE);

    // Since both bptPrice and notePrice are denominated in ETH, we can use
    // this formula to calculate noteAmount
    // bptBalance * bptPrice = notePrice * noteAmount
    // noteAmount = bptPrice / notePrice * bptBalance
    uint256 priceRatio = (bptPrice * 1e18) / notePrice;
    uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));

    // Amount_note = Price_NOTE_per_BPT * BPT_supply * 80% (80/20 pool)
    uint256 noteAmount = (priceRatio * bptBalance * 80) / 100;

    // Reduce precision down to 1e8 (NOTE token)
    // priceRatio and bptBalance are both 1e18 (1e36 total)
    // we divide by 1e28 to get to 1e8
    noteAmount /= 1e28;

    return (noteAmount * sNOTEAmount) / totalSupply();
}