function features() public view returns(uint256) {
    // according to new design features are stored in zero address
    // mapping of `userRoles` structure
    return userRoles[address(0)];
  }