function _mint(address account, uint256 value) internal virtual override {
        _updateAccountSnapshot(account);
        _updateTotalSupplySnapshot();

        super._mint(account, value);
    }