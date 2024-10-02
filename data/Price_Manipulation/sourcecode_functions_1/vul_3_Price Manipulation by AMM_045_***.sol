```solidity
function redeemRewards(uint128 validatorId, address beneficiary, uint128 amount) public {
    require(beneficiary != address(0x0), "Invalid beneficiary");
    require(amount != 0, "Cannot redeem 0 tokens");

    updateGlobalExchangeRate();

    Validator storage v = validators[validatorId];
    updateValidator(v);

    Staking storage s = v.stakings[msg.sender];
    uint128 rewards = sharesToTokens(s.shares, v.exchangeRate) - s.staked;

    if (msg.sender == v._address) {
        require(rewards + v.commissionAvailableToRedeem >= amount, "Cannot redeem more than available");

        // first redeem rewards from commission
        uint128 commissionLeftOver = amount < v.commissionAvailableToRedeem ? v.commissionAvailableToRedeem - amount : 0;

        // if there is more, redeem it from regular rewards
        if (commissionLeftOver == 0) {
            uint128 validatorSharesRemove = tokensToShares(amount - v.commissionAvailableToRedeem, v.exchangeRate);
            s.shares -= validatorSharesRemove;
            v.totalShares -= validatorSharesRemove;
        }

        v.commissionAvailableToRedeem = commissionLeftOver;
    } else {
        require(rewards >= amount, "Cannot redeem more than available");
        uint128 validatorSharesRemove = tokensToShares(amount, v.exchangeRate);
        s.shares -= validatorSharesRemove;
        v.totalShares -= validatorSharesRemove;
    }

    transferFromContract(beneficiary, amount);

    // update global shares #
    // this includes commission and rewards earned
    // only update if the validator is enabled, otherwise the shares were already excluded during disablement
    if (v.disabledEpoch == 0) {
        uint128 globalSharesRemove = tokensToShares(amount, globalExchangeRate);
        totalGlobalShares -= globalSharesRemove;
        v.globalShares -= globalSharesRemove;
    }

    emit RewardRedeemed(validatorId, beneficiary, amount);
}
```