function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }