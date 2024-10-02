function deposit(uint _amount) external {
    settlePendingObligation();
    // we want to protect new LPs, when the insurance fund is in deficit
    require(pendingObligation == 0, "IF.deposit.pending_obligations");

    uint _pool = balance();
    uint _totalSupply = totalSupply();
    if (_totalSupply == 0 && _pool > 0) { // trading fee accumulated while there were no IF LPs
        vusd.safeTransfer(governance, _pool);
        _pool = 0;
    }

    vusd.safeTransferFrom(msg.sender, address(this), _amount);
    uint shares = 0;
    if (_pool == 0) {
        shares = _amount;
    } else {
        shares = _amount * _totalSupply / _pool;
    }
    _mint(msg.sender, shares);
    emit FundsAdded(msg.sender, _amount, block.timestamp);
}