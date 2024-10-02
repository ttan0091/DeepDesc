function _transfer(address sender, address recipient, uint256 amount)
        internal
    {
        require(recipient != address(this), "can't send to MRC20");
        address(uint160(recipient)).transfer(amount);
        emit Transfer(sender, recipient, amount);
    }