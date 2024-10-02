function updateGlobalExchangeRate() internal {
    uint128 currentBlock = uint128(block.number);
    // if the program ended, set update epoch to the end epoch
    uint128 currentEpoch = currentBlock < endEpoch ? currentBlock : endEpoch;
    if (currentEpoch != lastUpdateEpoch) {
        // when no one has staked anything, do not update the rate
        if (totalGlobalShares > 0) {
            uint128 perEpochRateIncrease = uint128(uint256(allocatedTokensPerEpoch) * divider / uint256(totalGlobalShares));
            globalExchangeRate += perEpochRateIncrease * (currentEpoch - lastUpdateEpoch);
        }
        lastUpdateEpoch = currentEpoch;
    }
}