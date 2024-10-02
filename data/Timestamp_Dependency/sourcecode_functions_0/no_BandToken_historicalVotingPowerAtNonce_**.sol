function historicalVotingPowerAtNonce(address owner, uint256 nonce) public view returns (uint256) {
    require(nonce <= votingPowerChangeNonce && nonce < (1 << 64));
    uint256 start = 0;
    uint256 end = votingPowerChangeCount[owner];
    while (start < end) {
      uint256 mid = start.add(end).add(1).div(2); /// Use (start+end+1)/2 to prevent infinite loop.
      if ((_votingPower[owner][mid] >> 192) > nonce) {  /// Upper 64-bit nonce
        /// If midTime > nonce, this mid can't possibly be the answer.
        end = mid.sub(1);
      } else {
        /// Otherwise, search on the greater side, but still keep mid as a possible option.
        start = mid;
      }
    }
    return historicalVotingPowerAtIndex(owner, start);
  }