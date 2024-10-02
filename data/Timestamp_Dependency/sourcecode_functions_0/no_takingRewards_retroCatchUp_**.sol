function retroCatchUp() internal {
        // Failsafe check
        require(block.timestamp > periodFinish, "Period has not expired yet!");

        // Ensure the provided reward amount is not more than the balance in the contract.
        // This keeps the reward rate in the right range, preventing overflows due to
        // very high values of rewardRate in the earned and rewardsPerToken functions;
        // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
        uint256 num_periods_elapsed = uint256(block.timestamp.sub(periodFinish)) / rewardsDuration; // Floor division to the nearest period
        uint balance = rewardsToken.balanceOf(address(this));
        require(rewardRate.mul(rewardsDuration).mul(crBoostMultiplier()).mul(num_periods_elapsed + 1).div(PRICE_PRECISION) <= balance, "Not enough FXS available for rewards!");

        // uint256 old_lastUpdateTime = lastUpdateTime;
        // uint256 new_lastUpdateTime = block.timestamp;

        // lastUpdateTime = periodFinish;
        periodFinish = periodFinish.add((num_periods_elapsed.add(1)).mul(rewardsDuration));

        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();

        emit RewardsPeriodRenewed(address(stakingToken));
    }