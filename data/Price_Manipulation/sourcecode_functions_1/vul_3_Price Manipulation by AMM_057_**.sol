function getCollateralValueInMalt() public view returns (uint256 collateral) {
    uint256 maltPrice = maltDataLab.smoothedMaltPrice();
    uint256 target = maltDataLab.priceTarget();

    uint256 auctionPoolBalance = collateralToken.balanceOf(address(auctionPool)).mul(target).div(maltPrice);
    uint256 overflowBalance = collateralToken.balanceOf(address(rewardOverflow)).mul(target).div(maltPrice);
    uint256 liquidityExtensionBalance = collateralToken.balanceOf(address(liquidityExtension)).mul(target).div(maltPrice);
    uint256 swingTraderBalance = collateralToken.balanceOf(address(swingTrader)).mul(target).div(maltPrice);
    uint256 swingTraderMaltBalance = malt.balanceOf(address(swingTrader));

    return auctionPoolBalance + overflowBalance + liquidityExtensionBalance + swingTraderBalance + swingTraderMaltBalance;
}