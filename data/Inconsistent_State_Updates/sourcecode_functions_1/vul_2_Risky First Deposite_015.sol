function deposit(uint256 _amount) public returns (uint256 _mintAmount) {
    require(locked == false && paused == false, "ERROR: DEPOSIT_DISABLED");
    require(_amount > 0, "ERROR: DEPOSIT_ZERO");

    uint256 _supply = totalSupply();
    uint256 _totalLiquidity = totalLiquidity();
    vault.addValue(_amount, msg.sender, address(this));

    if (_supply > 0 && _totalLiquidity > 0) {
        _mintAmount = (_amount * _supply) / _totalLiquidity;
    } else if (_supply > 0 && _totalLiquidity == 0) {
        _mintAmount = _amount * _supply;
    } else {
        _mintAmount = _amount;
    }
    
    emit Deposit(msg.sender, _amount, _mintAmount);

    _mint(msg.sender, _mintAmount);

    uint256 _liquidityAfter = _totalLiquidity + _amount;
    uint256 _leverage = (totalAllocatedCredit * MAGIC_SCALE_1E6) / _liquidityAfter;

    if (targetLev - parameters.getLowerSlack(address(this)) > _leverage) {
        _adjustAlloc(_liquidityAfter);
    }
}