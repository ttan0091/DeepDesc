function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }