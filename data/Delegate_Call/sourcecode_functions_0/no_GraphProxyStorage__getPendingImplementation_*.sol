function _getPendingImplementation() internal view returns (address impl) {
        bytes32 slot = PENDING_IMPLEMENTATION_SLOT;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            impl := sload(slot)
        }
    }