function getLatestFLNQuote() internal view returns (uint256 dai_scx, uint256 daiBalanceOnBehodler) {
    uint256 daiToRelease = BehodlerLike(VARS.behodler).withdrawLiquidityFindSCX(
        VARS.DAI,
        10000,
        1 ether,
        VARS.precision
    );
    dai_scx = (daiToRelease * EXA) / (1 ether);
    daiBalanceOnBehodler = IERC20(VARS.DAI).balanceOf(VARS.behodler);
}