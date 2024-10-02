function deposit(uint256 _amount) public noContract(msg.sender) {
    require(_amount > 0, "INVALID_AMOUNT");
    uint256 balanceBefore = balance();
    token.safeTransferFrom(msg.sender, address(this), _amount);
    uint256 supply = totalSupply();
    uint256 shares;
    if (supply == 0) {
        shares = _amount;
    } else {
        // balanceBefore can't be 0 if totalSupply is > 0
        shares = (_amount * supply) / balanceBefore;
    }
    _mint(msg.sender, shares);

    emit Deposit(msg.sender, _amount);
}