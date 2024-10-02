function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }