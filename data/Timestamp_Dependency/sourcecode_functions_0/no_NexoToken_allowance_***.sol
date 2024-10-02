function allowance(address _owner, address _spender)
		public
		view
		returns (uint256 remaining)
	{   
		if (_spender != owner) {
			return allowed[_owner][_spender];
		}

		uint256 unlockedTokens;
		uint256 spentTokens;

		if (_owner == overdraftAllocation) {
			unlockedTokens = _calculateUnlockedTokens(
				overdraftCliff,
				overdraftPeriodLength,
				overdraftPeriodAmount,
				overdraftPeriodsNumber,
				overdraftUnvested
			);
			spentTokens = sub(overdraftTotal, balanceOf(overdraftAllocation));
		} else if (_owner == teamAllocation) {
			unlockedTokens = _calculateUnlockedTokens(
				teamCliff,
				teamPeriodLength,
				teamPeriodAmount,
				teamPeriodsNumber,
				teamUnvested
			);
			spentTokens = sub(teamTotal, balanceOf(teamAllocation));
		} else if (_owner == communityAllocation) {
			unlockedTokens = _calculateUnlockedTokens(
				communityCliff,
				communityPeriodLength,
				communityPeriodAmount,
				communityPeriodsNumber,
				communityUnvested
			);
			spentTokens = sub(communityTotal, balanceOf(communityAllocation));
		} else if (_owner == advisersAllocation) {
			unlockedTokens = _calculateUnlockedTokens(
				advisersCliff,
				advisersPeriodLength,
				advisersPeriodAmount,
				advisersPeriodsNumber,
				advisersUnvested
			);
			spentTokens = sub(advisersTotal, balanceOf(advisersAllocation));
		} else {
			return allowed[_owner][_spender];
		}

		return sub(unlockedTokens, spentTokens);
	}