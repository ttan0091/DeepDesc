function _mint(
    IERC20 foreignAsset,
    uint256 nativeDeposit,
    uint256 foreignDeposit,
    address from,
    address to
) internal nonReentrant returns (uint256 liquidity) {
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
        "BasePoolV2::mint: Insufficient Liquidity Provided"
    );

    uint256 id = positionId++;
    pair.totalSupply = totalLiquidityUnits + liquidity;
    _mint(to, id);

    positions[id] = Position(
        foreignAsset,
        block.timestamp,
        liquidity,
        nativeDeposit,
        foreignDeposit
    );

    // Update reserves
    _update(
        foreignAsset,
        reserveNative + nativeDeposit,
        reserveForeign + foreignDeposit,
        reserveNative,
        reserveForeign
    );

    emit Mint(from, to, nativeDeposit, foreignDeposit);
    emit PositionOpened(from, to, id, liquidity);

    return liquidity;
}