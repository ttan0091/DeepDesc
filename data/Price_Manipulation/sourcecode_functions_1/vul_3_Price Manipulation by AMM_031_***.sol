```solidity
function _depositAndProvideLiquidity(
    ITempusAMM tempusAMM,
    uint256 tokenAmount,
    bool isBackingToken
) private {
    (
        IVault vault,
        bytes32 poolId,
        IERC20[] memory ammTokens,
        uint256[] memory ammBalances
    ) = _getAMMDetailsAndEnsureInitialized(tempusAMM);

    uint256 mintedShares = _deposit(tempusAMM.tempusPool(), tokenAmount, isBackingToken);

    uint256[] memory sharesUsed = _provideLiquidity(
        address(this),
        vault,
        poolId,
        ammTokens,
        ammBalances,
        mintedShares,
        msg.sender
    );

    // Send remaining Shares to user
    if (sharesUsed[0] < mintedShares) {
        ammTokens[0].safeTransfer(msg.sender, mintedShares - sharesUsed[0]);
    }
    if (sharesUsed[1] < mintedShares) {
        ammTokens[1].safeTransfer(msg.sender, mintedShares - sharesUsed[1]);
    }
}
```