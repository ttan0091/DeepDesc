function mint(address _to, uint256 _amount) external onlyMinter canMint  returns (bool) {
    require(balances[_to] + _amount > balances[_to]); // Guard against overflow
    require(totalSupply + _amount > totalSupply);     // Guard against overflow  (this should never happen)
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    return true;
  }