function deposit(uint256 _amount) external returns (uint256 _mintAmount) {
    require(paused == false, "ERROR: PAUSED");
    require(_amount > 0, "ERROR: DEPOSIT_ZERO");

    // deposit and pay fees
    uint256 _liquidity = vault.attributionValue(crowdPool); // get USDC balance with crowdPool's att
    uint256 _supply = totalSupply();

    crowdPool += vault.addValue(_amount, msg.sender, address(this)); // increase attribution
    
    if (_supply > 0 && _liquidity > 0) {
        _mintAmount = (_amount * _supply) / _liquidity;
    } else if (_supply > 0 && _liquidity == 0) {
        // when vault lose all underwritten asset
        _mintAmount = _amount * _supply; // dilute LP token value af. Start CDS again.
    } else {
        // when _supply == 0,
        _mintAmount = _amount;
    }

    emit Deposit(msg.sender, _amount, _mintAmount);

    // mint iToken
    _mint(msg.sender, _mintAmount);
}