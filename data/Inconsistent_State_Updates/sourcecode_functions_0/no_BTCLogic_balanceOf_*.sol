function balanceOf(address owner) public view returns (uint256 balance) {
        return store.balanceOf(owner);
    }