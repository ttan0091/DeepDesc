function mint(address to)
    external
    override
    nonReentrant
    returns (uint256 liquidity)
{
    (uint112 reserveNative, uint112 reserveForeign, ) = getReserves(); // gas savings
    uint256 balanceNative = nativeAsset.balanceOf(address(this));
    uint256 balanceForeign = foreignAsset.balanceOf(address(this));
    uint256 nativeDeposit = balanceNative - reserveNative;
    uint256 foreignDeposit = balanceForeign - reserveForeign;

    uint256 totalLiquidityUnits = totalSupply;
    if (totalLiquidityUnits == 0) {
        liquidity = nativeDeposit; // TODO: Contact ThorChain on proper approach
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
        "BasePool::mint: Insufficient Liquidity Provided"
    );

    uint256 id = positionId++;
    totalSupply += liquidity;
    _mint(to, id);

    positions[id] = Position(
        block.timestamp,
        liquidity,
        nativeDeposit,
        foreignDeposit
    );

    _update(balanceNative, balanceForeign, reserveNative, reserveForeign);

    emit Mint(msg.sender, to, nativeDeposit, foreignDeposit);
    emit PositionOpened(msg.sender, id, liquidity);
}