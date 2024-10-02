function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }