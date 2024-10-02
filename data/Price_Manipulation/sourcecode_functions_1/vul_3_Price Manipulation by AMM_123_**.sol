function _rebalanceVault(uint256 underlyingToWithdraw) internal {
    IVault vault = getVault();
    if (address(vault) == address(0)) return;

    uint256 lockedLp = staker.getStakedByActions();
    uint256 totalUnderlyingStaked = lockedLp.scaledMul(exchangeRate());
    uint256 underlyingBalance = _getBalanceUnderlying(true);
    uint256 maximumDeviation = totalUnderlyingStaked.scaledMul(getMaxReserveDeviationRatio());
    uint256 nextTargetBalance = totalUnderlyingStaked.scaledMul(getRequiredReserveRatio());

    if (
        underlyingToWithdraw > underlyingBalance ||
        (underlyingBalance - underlyingToWithdraw) + maximumDeviation < nextTargetBalance
    ) {
        uint256 requiredDeposits = nextTargetBalance + underlyingToWithdraw - underlyingBalance;
        vault.withdraw(requiredDeposits);
    } else {
        uint256 nextBalance = underlyingBalance - underlyingToWithdraw;
        if (nextBalance > nextTargetBalance + maximumDeviation) {
            uint256 excessDeposits = nextBalance - nextTargetBalance;
            _doTransferOut(payable(address(vault)), excessDeposits);
            vault.deposit();
        }
    }
}