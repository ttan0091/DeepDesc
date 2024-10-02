function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }