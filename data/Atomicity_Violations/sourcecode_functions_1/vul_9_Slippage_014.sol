```solidity
function addLiquidity(
    IERC20 tokenA,
    IERC20 tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    address to,
    uint256 deadline
) public override ensure(deadline) returns (uint256 liquidity) {
    IERC20 foreignAsset;
    uint256 nativeDeposit;
    uint256 foreignDeposit;

    if (tokenA == nativeAsset) {
        require(
            pool.supported(tokenB),
            "VaderRouterV2::addLiquidity: Unsupported Assets Specified"
        );
        foreignAsset = tokenB;
        foreignDeposit = amountBDesired;
        nativeDeposit = amountADesired;
    } else {
        require(
            tokenB == nativeAsset && pool.supported(tokenA),
            "VaderRouterV2::addLiquidity: Unsupported Assets Specified"
        );
        foreignAsset = tokenA;
        foreignDeposit = amountADesired;
        nativeDeposit = amountBDesired;
    }

    liquidity = pool.mint(
        foreignAsset,
        nativeDeposit,
        foreignDeposit,
        msg.sender,
        to
    );
}
```