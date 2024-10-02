function approve(address _spender, uint256 _value) public whenNotPaused
      returns (bool) {
      return super.approve(_spender, _value);
    }