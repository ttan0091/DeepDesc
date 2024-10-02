function maltMarketPrice() public view returns (uint256 price, uint256 decimals) {
    // TODO use datalab anywhere that calls this Tue 05 Oct 2021 20:56:41 BST
    (uint256 maltReserves, uint256 rewardReserves) = UniswapV2Library.getReserves(
        uniswapV2Factory,
        address(malt),
        address(rewardToken)
    );

    if (maltReserves == 0 || rewardReserves == 0) {
        price = 0;
        decimals = 18;
        return (price, decimals);
    }

    uint256 rewardDecimals = rewardToken.decimals();
    uint256 maltDecimals = malt.decimals();

    if (rewardDecimals > maltDecimals) {
        uint256 diff = rewardDecimals - maltDecimals;
        price = rewardReserves.mul(10**rewardDecimals).div(maltReserves.mul(10**diff));
        decimals = rewardDecimals;
    } else if (rewardDecimals < maltDecimals) {
        uint256 diff = maltDecimals - rewardDecimals;
        price = (rewardReserves.mul(10**diff)).mul(10**rewardDecimals).div(maltReserves);
        decimals = maltDecimals;
    } else {
        price = rewardReserves.mul(10**rewardDecimals).div(maltReserves);
        decimals = rewardDecimals;
    }
    return (price, decimals);
}