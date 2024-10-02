function mintFor(address asset, uint _withdrawalFee, uint _performanceFee, address to, uint) 
    external 
{
    uint feeSum = _performanceFee.add(_withdrawalFee);
    _transferAsset(asset, feeSum);

    if (asset == BUNNY) {
        IBEP20(BUNNY).safeTransfer(DEAD, feeSum);
        return;
    }

    uint bunnyBNBAmount = _zapAssetsToBunnyBNB(asset, feeSum, false);
    if (bunnyBNBAmount == 0) return;

    IBEP20(BUNNY_BNB).safeTransfer(BUNNY_POOL, bunnyBNBAmount);
    IStakingRewards(BUNNY_POOL).notifyRewardAmount(bunnyBNBAmount);

    (uint valueInBNB,) = priceCalculator.valueOfAsset(BUNNY_BNB, bunnyBNBAmount);
    uint contribution = valueInBNB.mul(_performanceFee).div(feeSum);
    uint mintBunny = amountBunnyToMint(contribution);
    if (mintBunny == 0) return;
    _mint(mintBunny, to);
}