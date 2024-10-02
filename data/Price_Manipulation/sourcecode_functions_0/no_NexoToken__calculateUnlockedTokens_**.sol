function _calculateUnlockedTokens(
		uint256 _cliff,
		uint256 _periodLength,
		uint256 _periodAmount,
		uint8 _periodsNumber,
		uint256 _unvestedAmount
	)
		private
		view
		returns (uint256) 
	{
		/* solium-disable-next-line security/no-block-members */
		if (now < add(creationTime, _cliff)) {
			return _unvestedAmount;
		}
		/* solium-disable-next-line security/no-block-members */
		uint256 periods = div(sub(now, add(creationTime, _cliff)), _periodLength);
		periods = periods > _periodsNumber ? _periodsNumber : periods;
		return add(_unvestedAmount, mul(periods, _periodAmount));
	}