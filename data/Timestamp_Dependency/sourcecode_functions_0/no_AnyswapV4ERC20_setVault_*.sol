function setVault(address _vault) external onlyVault {
        pendingVault = _vault;
        delayVault = block.timestamp + delay;
    }