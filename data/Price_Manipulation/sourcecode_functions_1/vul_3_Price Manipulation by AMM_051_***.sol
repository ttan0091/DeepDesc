function _burn(uint256 id, address to)
    internal
    nonReentrant
    returns (uint256 amountNative, uint256 amountForeign)
{
    require(
        ownerOf(id) == address(this),
        "BasePoolV2::burn: Incorrect Ownership"
    );

    IERC20 foreignAsset = positions[id].foreignAsset;

    (uint112 reserveNative, uint112 reserveForeign, ) = getReserves(foreignAsset); // gas savings

    uint256 liquidity = positions[id].liquidity;

    PairInfo storage pair = pairInfo[foreignAsset];
    uint256 _totalSupply = pair.totalSupply;
    amountNative = (liquidity * reserveNative) / _totalSupply;
    amountForeign = (liquidity * reserveForeign) / _totalSupply;

    require(
        amountNative > 0 && amountForeign > 0,
        "BasePoolV2::burn: Insufficient Liquidity Burned"
    );

    pair.totalSupply = _totalSupply - liquidity;
    _burn(id);

    nativeAsset.safeTransfer(to, amountNative);
    foreignAsset.safeTransfer(to, amountForeign);

    _update(
        foreignAsset,
        reserveNative - amountNative,
        reserveForeign - amountForeign,
        reserveNative,
        reserveForeign
    );

    emit Burn(msg.sender, amountNative, amountForeign, to);
}