function acceptAdmin() external returns (bool) {
		if (msg.sender != pendingAdmin || msg.sender == address(0)) {
			revert('BitDAO:acceptAdmin:illegal address');
		}
		address oldAdmin = admin;
		address oldPendingAdmin = pendingAdmin;
		admin = pendingAdmin;
		pendingAdmin = address(0);

		emit NewAdmin(oldAdmin, admin);
		emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);

		return true;
	}