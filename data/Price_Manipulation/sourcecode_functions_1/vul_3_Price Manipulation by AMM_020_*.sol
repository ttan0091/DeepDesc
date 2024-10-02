function latestAnswer() public view returns (uint256) {
    uint256 crvPoolBtcVal = WBTC.balanceOf(address(CRV3CRYPTO)) * uint256(BTCFeed.latestAnswer());
    uint256 crvPoolWethVal = WETH.balanceOf(address(CRV3CRYPTO)) * uint256(ETHFeed.latestAnswer());
    uint256 crvPoolUsdtVal = USDT.balanceOf(address(CRV3CRYPTO)) * uint256(USDTFeed.latestAnswer());

    uint256 crvLPTokenPrice = (crvPoolBtcVal + crvPoolWethVal + crvPoolUsdtVal) * 1e18 / CRV3CRYPTO.totalSupply();

    return (crvLPTokenPrice * vault.pricePerShare()) / 1e18;
}