function delegatedTransferERC20(
    address token,
    address to,
    uint256 amount
) external {
    if (msg.sender != _getOwner()) {
        require(
            erc20Approvals[keccak256(abi.encodePacked(msg.sender, token))] >= amount,
            "Account not approved to transfer amount"
        );
    }

    // check for sufficient balance
    require(
        IERC20(token).balanceOf(address(this)) >= (getBalanceLocked(token).add(amount)).add(timelockERC20Balances[token]),
        "Insufficient balance"
    );
}