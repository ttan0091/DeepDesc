function _overflowDuring(
    IJBSingleTokenPaymentTerminal _terminal,
    uint256 _projectId,
    JBFundingCycle memory _fundingCycle,
    uint256 _balanceCurrency
) private view returns (uint256) {
    // Get the current balance of the project.
    uint256 _balanceOf = balanceOf[_terminal][_projectId];
    // If there's no balance, there's no overflow.
    if (_balanceOf == 0) return 0;

    // Get a reference to the distribution limit during the funding cycle.
    (uint256 _distributionLimit, uint256 _distributionLimitCurrency) = IJBController(
        directory.controllerOf(_projectId)
    ).distributionLimitOf(_projectId, _fundingCycle.configuration, _terminal, _terminal.token());

    // Get a reference to the amount still distributable during the funding cycle.
    uint256 _distributionLimitRemaining = _distributionLimit -
        usedDistributionLimitOf[_terminal][_projectId][_fundingCycle.number];

    // Convert the _distributionLimitRemaining to be in terms of the provided currency.
    if (_distributionLimitRemaining != 0 && _distributionLimitCurrency != _balanceCurrency) {
        _distributionLimitRemaining = PRBMath.mulDiv(
            _distributionLimitRemaining,
            10**_MAX_FIXED_POINT_FIDELITY, // Use _MAX_FIXED_POINT_FIDELITY to keep as much precision as possible
            prices.priceFor(_distributionLimitCurrency, _balanceCurrency, _MAX_FIXED_POINT_FIDELITY)
        );
    }

    // Overflow is the balance of this project minus the amount that can still be distributed.
    return _balanceOf > _distributionLimitRemaining ? _balanceOf - _distributionLimitRemaining : 0;
}