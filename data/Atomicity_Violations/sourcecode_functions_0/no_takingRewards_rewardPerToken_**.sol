function rewardPerToken() public override view returns (uint256) {
        if (_staking_token_supply == 0) {
            return rewardPerTokenStored;
        }
        else {
            return rewardPerTokenStored.add(
                lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(crBoostMultiplier()).mul(1e18).div(PRICE_PRECISION).div(_staking_token_boosted_supply)
            );
        }
    }