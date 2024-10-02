function approve(address _spender, uint256 _value) public returns (bool success)`
   *
   * @dev Caller must not necessarily own any tokens to grant the permission
   *
   * @param _spender an address approved by the caller (token owner)
   *      to spend some tokens on its behalf
   * @param _value an amount of tokens spender `_spender` is allowed to
   *      transfer on behalf of the token owner
   * @return success true on success, throws otherwise
   */
  function approve(address _spender, uint256 _value) public returns (bool success) {
    // non-zero spender address check - Zeppelin
    // obviously, zero spender address is a client mistake
    // it's not part of ERC20 standard but it's reasonable to fail fast
    require(_spender != address(0), "ERC20: approve to the zero address"); // Zeppelin msg

    // read old approval value to emmit an improved event (ISBN:978-1-7281-3027-9)
    uint256 _oldValue = transferAllowances[msg.sender][_spender];

    // perform an operation: write value requested into the storage
    transferAllowances[msg.sender][_spender] = _value;

    // emit an improved atomic approve event (ISBN:978-1-7281-3027-9)
    emit Approved(msg.sender, _spender, _oldValue, _value);

    // emit an ERC20 approval event
    emit Approval(msg.sender, _spender, _value);

    // operation successful, return true
    return true;
  }