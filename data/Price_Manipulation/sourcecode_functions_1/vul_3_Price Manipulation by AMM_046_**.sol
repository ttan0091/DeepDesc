function updateValidator(Validator storage v) internal {
    // if validator is disabled, we do not update it since it was updated during disabling transaction
    if (v.disabledEpoch == 0) {
        if (v.totalShares == 0) {
            // when validator stakes the first time, the exchange rate must be equal to the current global exchange rate
            v.exchangeRate = globalExchangeRate;
        } else {
            // the growth of global exchange rate since the validator was updated the last time
            uint128 rateDifference = globalExchangeRate - v.lastUpdateGlobalRate;
            // tokens given to the validator and its delegators since last update
            uint128 tokensGivenToValidator = sharesToTokens(v.globalShares, rateDifference);
            // commission paid out of the tokens
            uint128 commissionPaid = uint128(uint256(tokensGivenToValidator) * uint256(v.commissionRate) / uint256(divider));
            // increase validator exchange rate by distributing the leftover tokens through the validator's shares
            v.exchangeRate += uint128(uint256(tokensGivenToValidator - commissionPaid) * divider / uint256(v.totalShares));
            // give commission tokens to the validator
            v.commissionAvailableToRedeem += commissionPaid;
        }
        // set the last update global rate to the current one
        v.lastUpdateGlobalRate = globalExchangeRate;
    }
}