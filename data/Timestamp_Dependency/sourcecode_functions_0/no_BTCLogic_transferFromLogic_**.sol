function transferFromLogic(address sender,address from,address to,uint256 value) external onlyCaller returns(bool) {
        require(from != address(0), "cannot transfer from address zero");
        require(to != address(0), "cannot transfer to address zero");
        require(value > 0, "can not tranfer zero Token");
        require(from!=to,"from and to can not be be the same ");
        require(address(store) != address(0), "dataStore address error");

        uint256 balanceFrom = store.balanceOf(from);
        uint256 balanceTo = store.balanceOf(to);
        uint256 allowedvalue = store.getAllowed(from,sender);

        require(value <= allowedvalue, "insufficient allowance");
        require(value <= balanceFrom, "insufficient funds");

        balanceFrom = balanceFrom.safeSub(value);
        balanceTo = balanceTo.safeAdd(value);
        allowedvalue = allowedvalue.safeSub(value);

        store.setBalance(from,balanceFrom);
        store.setBalance(to,balanceTo);
        store.setAllowed(from,sender,allowedvalue);
        return true;
    }