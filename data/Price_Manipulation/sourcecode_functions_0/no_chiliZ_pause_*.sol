function pause() public onlyPauser whenNotPaused {
    _paused = true;
    emit Paused(msg.sender);
  }