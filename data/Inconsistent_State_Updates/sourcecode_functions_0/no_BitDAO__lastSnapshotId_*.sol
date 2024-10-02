function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
		if (ids.length == 0) {
			return 0;
		} else {
			return ids[ids.length - 1];
		}
	}