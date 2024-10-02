function _writeSnapshot(address owner, uint128 oldValue, uint128 newValue) internal {
        uint128 currentBlock = uint128(block.number);

        uint256 ownerCountOfSnapshots = _countsSnapshots[owner];
        mapping (uint256 => Snapshot) storage snapshotsOwner = _snapshots[owner];

        // Doing multiple operations in the same block
        if (ownerCountOfSnapshots != 0 && snapshotsOwner[ownerCountOfSnapshots.sub(1)].blockNumber == currentBlock) {
            snapshotsOwner[ownerCountOfSnapshots.sub(1)].value = newValue;
        } else {
            snapshotsOwner[ownerCountOfSnapshots] = Snapshot(currentBlock, newValue);
            _countsSnapshots[owner] = ownerCountOfSnapshots.add(1);
        }

        emit SnapshotDone(owner, oldValue, newValue);
    }