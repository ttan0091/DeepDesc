function mintFungible(
    IERC20 foreignAsset,
    uint256 nativeDeposit,
    uint256 foreignDeposit,
    address from,
    address to
) external override nonReentrant returns (uint256 liquidity) {
    IERC20Extended lp = wrapper.tokens(foreignAsset);

    require(
        lp != IERC20Extended(_ZERO_ADDRESS),
        "VaderPoolV2::mintFungible: Unsupported Token"
    );

    (uint112 reserveNative, uint112 reserveForeign, ) = getReserves(foreignAsset); // gas savings

    nativeAsset.safeTransferFrom(from, address(this), nativeDeposit);
    foreignAsset.safeTransferFrom(from, address(this), foreignDeposit);

    PairInfo storage pair = pairInfo[foreignAsset];
    uint256 totalLiquidityUnits = pair.totalSupply;
    if (totalLiquidityUnits == 0) {
        liquidity = nativeDeposit;
    } else {
        liquidity = VaderMath.calculateLiquidityUnits(
            nativeDeposit,
            reserveNative,
            foreignDeposit,
            reserveForeign,
            totalLiquidityUnits
        );
    }

    require(
        liquidity > 0,
        "VaderPoolV2::mintFungible: Insufficient Liquidity Provided"
    );

    pair.totalSupply = totalLiquidityUnits + liquidity;

    // Update reserves
    _update(
        foreignAsset,
        reserveNative + nativeDeposit,
        reserveForeign + foreignDeposit,
        reserveNative,
        reserveForeign
    );

    lp.mint(to, liquidity);

    emit Mint(from, to, nativeDeposit, foreignDeposit);
}