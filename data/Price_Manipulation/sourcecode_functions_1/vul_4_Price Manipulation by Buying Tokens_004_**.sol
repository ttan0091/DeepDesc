function _buyVaultToken(
    address vault,
    uint256 minTokenOut,
    uint256 maxWethIn,
    address[] calldata path
) internal returns (uint256[] memory) {
    uint256[] memory amounts = sushiRouter.swapTokensForExactTokens(
        minTokenOut,
        maxWethIn,
        path,
        address(this),
        block.timestamp
    );

    return amounts;
}