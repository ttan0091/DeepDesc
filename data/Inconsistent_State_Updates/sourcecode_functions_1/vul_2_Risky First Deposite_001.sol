function deposit(uint256 _amount) external returns (uint256) {
    uint256 _pool = balance();
    uint256 _before = token.balanceOf(address(this));
    token.safeTransferFrom(msg.sender, address(this), _amount);
    uint256 _after = token.balanceOf(address(this));
    _amount = _after.sub(_before); // Additional check for deflationary tokens
    uint256 _shares = 0;
    if (totalSupply() == 0) {
        _shares = _amount;
    } else {
        _shares = (_amount.mul(totalSupply())).div(_pool);
    }
    _mint(msg.sender, _shares);
}