function balanceOf(address _recipient) external view override returns (uint256) {
    uint256 timestamp = block.timestamp;
    uint256 timeRevoked = revokedTime[_recipient];
    if (timeRevoked != 0) {
        timestamp = timeRevoked;
    }
    return _balanceOf(_recipient, timestamp);
}