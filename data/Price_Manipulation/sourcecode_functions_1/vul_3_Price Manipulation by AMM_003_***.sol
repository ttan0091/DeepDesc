function _zapAssetsToBunnyBNB(address asset, uint amount, bool fromV2) 
    private 
    returns (uint bunnyBNBAmount) 
{
    uint _initBunnyBNBAmount = IBEP20(BUNNY_BNB).balanceOf(address(this));
    
    if (asset == address(0)) {
        zapBSC.zapIn{ value : amount }(BUNNY_BNB);
    } 
    else if (keccak256(abi.encodePacked(IPancakePair(asset).symbol())) == keccak256("Cake-LP")) {
        IPancakeRouter02 router = fromV2 ? routerV2 : routerV1;
        
        if (IBEP20(asset).allowance(address(this), address(router)) == 0) {
            IBEP20(asset).safeApprove(address(router), uint(-1));
        }
        
        IPancakePair pair = IPancakePair(asset);
        address token0 = pair.token0();
        address token1 = pair.token1();
        
        (uint amountToken0, uint amountToken1) = router.removeLiquidity(token0, token1, amount, 0, 0);
        
        if (IBEP20(token0).allowance(address(this), address(zapBSC)) == 0) {
            IBEP20(token0).safeApprove(address(zapBSC), uint(-1));
        }
        
        if (IBEP20(token1).allowance(address(this), address(zapBSC)) == 0) {
            IBEP20(token1).safeApprove(address(zapBSC), uint(-1));
        }
        
        zapBSC.zapInToken(token0, amountToken0, BUNNY_BNB);
        zapBSC.zapInToken(token1, amountToken1, BUNNY_BNB);
    } 
    else {
        if (IBEP20(asset).allowance(address(this), address(zapBSC)) == 0) {
            IBEP20(asset).safeApprove(address(zapBSC), uint(-1));
        }
        zapBSC.zapInToken(asset, amount, BUNNY_BNB);
    }
    
    bunnyBNBAmount = IBEP20(BUNNY_BNB).balanceOf(address(this)).sub(_initBunnyBNBAmount);
}

