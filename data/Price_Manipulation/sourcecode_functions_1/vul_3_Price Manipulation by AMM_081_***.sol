function stabilizeFlan(uint256 rectangleOfFairness) 
    public 
    override 
    onlyLimbo 
    ensurePriceStability 
{
    uint256 localSCXBalance = IERC20(VARS.behodler).balanceOf(address(this));

    // SCX transfers incur a 2% fee. Checking that SCX balance === rectangleOfFairness must take this into account.
    // Note that for hardcoded values, this contract can be upgraded through governance so we're not ignoring it.
    require((localSCXBalance * 100) / rectangleOfFairness == 98, "EM");
    rectangleOfFairness = localSCXBalance;

    // Get DAI per SCX
    uint256 existingSCXBalanceOnLP = IERC20(VARS.behodler).balanceOf(address(VARS.Flan_SCX_tokenPair));
    uint256 finalSCXBalanceOnLP = existingSCXBalanceOnLP + rectangleOfFairness;

    // The DAI value of SCX is the final quantity of Flan because we want Flan to hit parity with Dai.
    uint256 DesiredFinalFlanOnLP = (finalSCXBalanceOnLP * latestFlanQuotes[0].DaiScxSpotPrice) / EXA;
    address pair = address(VARS.Flan_SCX_tokenPair);
    uint256 existingFlanOnLP = IERC20(VARS.flan).balanceOf(pair);

    if (existingFlanOnLP < DesiredFinalFlanOnLP) {
        uint256 flanToMint = ((DesiredFinalFlanOnLP - existingFlanOnLP) * (100 - VARS.priceBoostOvershoot)) / 100;
        
        flanToMint = flanToMint == 0 ? DesiredFinalFlanOnLP - existingFlanOnLP : flanToMint;
        FlanLike(VARS.flan).mint(pair, flanToMint);
        IERC20(VARS.behodler).transfer(pair, rectangleOfFairness);
        lpMinted = VARS.Flan_SCX_tokenPair.mint(VARS.blackHole);
    } else {
        uint256 minFlan = existingFlanOnLP / VARS.Flan_SCX_tokenPair.totalSupply();
        
        FlanLike(VARS.flan).mint(pair, minFlan + 2);
        IERC20(VARS.behodler).transfer(pair, rectangleOfFairness);
        lpMinted = VARS.Flan_SCX_tokenPair.mint(VARS.blackHole);
    }

    // Don't allow future migrations to piggy back off the data collected by recent migrations. Forces a reset.
    _zeroOutQuotes();
}