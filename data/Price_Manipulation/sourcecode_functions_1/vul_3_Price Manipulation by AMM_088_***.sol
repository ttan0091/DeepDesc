function _claimCollateral(uint256 _collateralTokenId, uint256 _amount)
    internal
{
    uint256 collateralTokenId = _collateralTokenId;
    // Use the QuantCalculator to check how much collateral the sender/signer is due.
    (
        uint256 returnableCollateral,
        address collateralAsset,
        uint256 amountToClaim
    ) = IQuantCalculator(quantCalculator).calculateClaimableCollateral(
        collateralTokenId,
        _amount
    );

    // Burn the short tokens
    IOptionsFactory(optionsFactory).collateralToken().burnCollateralToken(
        _msgSender(),
        collateralTokenId,
        amountToClaim
    );

    // Transfer any collateral due after expiration
    if (returnableCollateral > 0) {
        IERC20(collateralAsset).safeTransfer(
            _msgSender(),
            returnableCollateral
        );
    }

    emit CollateralClaimed(
        _msgSender(),
        collateralTokenId,
        amountToClaim,
        returnableCollateral,
        collateralAsset
    );
}