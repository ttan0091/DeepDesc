function __binaryLookup(address _to, uint256 n) private view returns(uint256) {
    // get a link to an array of voting power history records for an address specified
    VotingPowerRecord[] storage history = votingPowerHistory[_to];

    // left bound of the search interval, originally start of the array
    uint256 i = 0;

    // right bound of the search interval, originally end of the array
    uint256 j = history.length - 1;

    // the iteration process narrows down the bounds by
    // splitting the interval in a half oce per each iteration
    while(j > i) {
      // get an index in the middle of the interval [i, j]
      uint256 k = j - (j - i) / 2;

      // read an element to compare it with the value of interest
      VotingPowerRecord memory cp = history[k];

      // if we've got a strict equal - we're lucky and done
      if(cp.blockNumber == n) {
        // just return the result - index `k`
        return k;
      }
      // if the value of interest is bigger - move left bound to the middle
      else if (cp.blockNumber < n) {
        // move left bound `i` to the middle position `k`
        i = k;
      }
      // otherwise, when the value of interest is smaller - move right bound to the middle
      else {
        // move right bound `j` to the middle position `k - 1`:
        // element at position `k` is bigger and cannot be the result
        j = k - 1;
      }
    }

    // reaching that point means no exact match found
    // since we're interested in the element which is not bigger than the
    // element of interest, we return the lower bound `i`
    return i;
  }