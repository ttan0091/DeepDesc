function init(
    address _to,
    uint256 _amount,
    address _minter
) external {
    require(msg.sender == operator, "Only operator");
    require(totalSupply() == 0, "Only once");
    require(_amount > 0, "Must mint something");
    require(_minter != address(0), "Invalid minter");

    _mint(_to, _amount);
    updateOperator();
    minter = _minter;
    minterMinted = 0;

    emit Initialised();
}