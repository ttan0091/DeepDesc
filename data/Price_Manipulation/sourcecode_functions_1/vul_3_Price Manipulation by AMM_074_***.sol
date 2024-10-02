function viewCapitalRequirements(uint256 _sherAmountWant)
    public
    view
    returns (
        uint256 sherAmount,
        uint256 stake,
        uint256 price
    )
{
    // Only allow if liquidity event is active
    if (active() == false) revert InvalidState();
    // Zero isn't allowed
    if (_sherAmountWant == 0) revert ZeroArgument();

    // View how much SHER is still available to be sold
    uint256 available = sher.balanceOf(address(this));
    // If remaining SHER is 0 it's sold out
    if (available == 0) revert SoldOut();

    // Use remaining SHER if it's less than `_sherAmountWant`, otherwise go for `_sherAmountWant`
    // Remaining SHER will only be assigned on the last sale of this contract, `SoldOut()` error will be thrown
    // sherAmount is not able to be zero as both 'available' and '_sherAmountWant' will be bigger than zero
    sherAmount = available < _sherAmountWant ? available : _sherAmountWant;
    // Only allows SHER amounts with certain precision steps
    // To ensure there is no rounding error at loss for the contract in stake / price calculation
    // Theoretically, if `available` is used, the function can fail if '% SHER_STEPS != 0' will be true
    // This can be caused by a griefer sending a small amount of SHER to the contract
    // Realistically, no SHER tokens will be on the market when this function is active
    // So it can only be caused if the admin sends too small amounts (documented at top of file with @d)
    if (sherAmount % SHER_STEPS != 0) revert InvalidAmount();

    // Calculate how much USDC needs to be staked to buy `sherAmount`
    stake = (sherAmount * stakeRate) / SHER_DECIMALS;
    // Calculate how much USDC needs to be paid to buy `sherAmount`
    price = (sherAmount * buyRate) / SHER_DECIMALS;
}