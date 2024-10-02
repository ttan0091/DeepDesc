function mintSynth(
    IERC20 foreignAsset,
    uint256 nativeDeposit,
    address from,
    address to
)
    external
    override
    nonReentrant
    supportedToken(foreignAsset)
    returns (uint256 amountSynth)
{
    nativeAsset.safeTransferFrom(from, address(this), nativeDeposit);

    ISynth synth = synthFactory.synths(foreignAsset);

    if (synth == ISynth(_ZERO_ADDRESS)) {
        synth = synthFactory.createSynth(IERC20Extended(address(foreignAsset)));
    }

    (uint112 reserveNative, uint112 reserveForeign, ) = getReserves(foreignAsset); // gas savings

    amountSynth = VaderMath.calculateSwap(
        nativeDeposit,
        reserveNative,
        reserveForeign
    );

    _update(
        foreignAsset,
        reserveNative + nativeDeposit,
        reserveForeign,
        reserveNative,
        reserveForeign
    );

    synth.mint(to, amountSynth);
}