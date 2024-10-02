function setUpgradeAgent(address agent) external {

        require(canUpgrade(), "It's required to be in canUpgrade() condition when setting upgrade agent.");

        require(agent != address(0), "Agent is required to be an non-empty address when setting upgrade agent.");

        // Only a master can designate the next agent
        require(msg.sender == upgradeMaster, "Message sender is required to be the upgradeMaster when setting upgrade agent.");

        // Upgrade has already begun for an agent
        require(getUpgradeState() != UpgradeState.ReadyToUpgrade, "Upgrade state is required to not be upgrading when setting upgrade agent.");

        require(address(upgradeAgent) == address(0), "upgradeAgent once set, cannot be reset");

        upgradeAgent = UpgradeAgent(agent);

        // Bad interface
        require(upgradeAgent.isUpgradeAgent(), "The provided updateAgent contract is required to be compliant to the UpgradeAgent interface method when setting upgrade agent.");

        // Make sure that token supplies match in source and target
        require(upgradeAgent.originalSupply() == totalSupply_, "The provided upgradeAgent contract's originalSupply is required to be equivalent to existing contract's totalSupply_ when setting upgrade agent.");

        emit UpgradeAgentSet(upgradeAgent);
    }