function withdraw(uint256 _amount) external {
    UserInfo storage user = userInfo[msg.sender];
    require(
        user.amount >= _amount,
        "RocketJoeStaking: withdraw amount exceeds balance"
    );

    updatePool();

    uint256 pending = (user.amount * accRJoePerShare) /
        PRECISION -
        user.rewardDebt;

    user.amount = user.amount - _amount;
    user.rewardDebt = (user.amount * accRJoePerShare) / PRECISION;

    _safeRJoeTransfer(msg.sender, pending);
    joe.safeTransfer(address(msg.sender), _amount);
    emit Withdraw(msg.sender, _amount);
}