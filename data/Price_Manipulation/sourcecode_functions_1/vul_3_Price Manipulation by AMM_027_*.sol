function get(bytes32 base, bytes32 kind, uint256 amount) public virtual override view returns (uint256 value, uint256 updateTime) {
    uint256 price;
    (price, updateTime) = _peek(base.b6(), kind.b6());
    value = price * amount / 1e18;
}