function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }