function migrateBridgeRole(address newBridgeRoleAddress) public {
        require(bridgeRoles.has(msg.sender), "Unauthorized.");
        bridgeRoles.remove(msg.sender);
        bridgeRoles.add(newBridgeRoleAddress);
        emit MigrateBridgeRole(newBridgeRoleAddress);
    }