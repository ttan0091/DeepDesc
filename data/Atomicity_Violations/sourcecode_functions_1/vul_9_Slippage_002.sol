function burnSynth(
    IERC20 foreignAsset,
    uint256 synthAmount,
    address to
) external override nonReentrant returns (uint256 amountNative) {
    ISynth synth = synthFactory.synths(foreignAsset);

    require(
        synth != ISynth(_ZERO_ADDRESS),
        "VaderPoolV2::burnSynth: Inexistent Synth"
    );

    require(
        synthAmount > 0,
        "VaderPoolV2::burnSynth: Insufficient Synth Amount"
    );

    IERC20(synth).safeTransferFrom(msg.sender, address(this), synthAmount);
    synth.burn(synthAmount);

    (uint112 reserveNative, uint112 reserveForeign, ) = getReserves(foreignAsset);

    amountNative = VaderMath.calculateSwap(
        synthAmount,
        reserveForeign,
        reserveNative
    );

    _update(
        foreignAsset,
        reserveNative - amountNative,
        reserveForeign,
        reserveNative,
        reserveForeign
    );

    nativeAsset.safeTransfer(to, amountNative);
}