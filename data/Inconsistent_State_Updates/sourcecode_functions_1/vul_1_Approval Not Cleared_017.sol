function setEYEBasedAssetStake(
    uint256 finalAssetBalance,
    uint256 finalEYEBalance,
    uint256 rootEYE,
    address asset
) public isLive incrementFate {
    require(assetApproved[asset], "LimboDAO: illegal asset");
    address sender = _msgSender();
    FateGrowthStrategy strategy = fateGrowthStrategy[asset];

    uint256 rootEYESquared = rootEYE * rootEYE;
    uint256 rootEYEPlusOneSquared = (rootEYE + 1) * (rootEYE + 1);
    require(
        rootEYESquared <= finalEYEBalance && rootEYEPlusOneSquared > finalEYEBalance,
        "LimboDAO: Stake EYE invariant."
    );
    
    AssetClout storage clout = stakedUserAssetWeight[sender][asset];
    fateState[sender].fatePerDay -= clout.fateWeight;
    uint256 initialBalance = clout.balance;

    if (strategy == FateGrowthStrategy.directRoot) {
        require(finalAssetBalance == finalEYEBalance, "LimboDAO: staking eye invariant.");
        require(asset == domainConfig.eye);

        clout.fateWeight = rootEYE;
        clout.balance = finalAssetBalance;
        fateState[sender].fatePerDay += rootEYE;
    } else if (strategy == FateGrowthStrategy.indirectTwoRootEye) {
        clout.fateWeight = 2 * rootEYE;
        fateState[sender].fatePerDay += clout.fateWeight;

        uint256 actualEyeBalance = IERC20(domainConfig.eye).balanceOf(asset);
        require(actualEyeBalance > 0, "LimboDAO: No EYE");
        uint256 totalSupply = IERC20(asset).totalSupply();
        uint256 eyePerUnit = (actualEyeBalance * ONE) / totalSupply;
        uint256 impliedEye = (eyePerUnit * finalAssetBalance) / (ONE * precision);
        finalEYEBalance /= precision;
        require(
            finalEYEBalance == impliedEye,
            "LimboDAO: stake invariant check 2."
        );
        clout.balance = finalAssetBalance;
    } else {
        revert("LimboDAO: asset growth strategy not accounted for");
    }
    
    int256 netBalance = int256(finalAssetBalance) - int256(initialBalance);
    asset.ERC20NetTransfer(sender, address(this), netBalance);
}