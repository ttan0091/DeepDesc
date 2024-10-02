function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {

        // We don't do interface check here as we might want to a normal wallet address to act as a release agent
        releaseAgent = addr;
    }