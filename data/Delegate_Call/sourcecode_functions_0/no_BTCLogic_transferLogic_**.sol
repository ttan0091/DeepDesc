function transferLogic(address sender,address to,uint256 value) external onlyCaller returns(bool) {
        require(to != address(0), "cannot transfer to address zero");
        require(sender != to, "sender need != to");
        require(value > 0, "value need > 0");
        require(address(store) != address(0), "dataStore address error");

        uint256 balanceFrom = store.balanceOf(sender);
        uint256 balanceTo = store.balanceOf(to);
        require(value <= balanceFrom, "insufficient funds");
        balanceFrom = balanceFrom.safeSub(value);
        balanceTo = balanceTo.safeAdd(value);
        store.setBalance(sender,balanceFrom);
        store.setBalance(to,balanceTo);
        return true;
    }