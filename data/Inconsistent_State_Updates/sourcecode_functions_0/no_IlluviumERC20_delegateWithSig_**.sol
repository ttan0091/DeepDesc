function delegateWithSig(address _to, uint256 _nonce, uint256 _exp, uint8 v, bytes32 r, bytes32 s) public {
    // verify delegations on behalf are enabled
    require(isFeatureEnabled(FEATURE_DELEGATIONS_ON_BEHALF), "delegations on behalf are disabled");

    // build the EIP-712 contract domain separator
    bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), block.chainid, address(this)));

    // build the EIP-712 hashStruct of the delegation message
    bytes32 hashStruct = keccak256(abi.encode(DELEGATION_TYPEHASH, _to, _nonce, _exp));

    // calculate the EIP-712 digest "\x19\x01" ‖ domainSeparator ‖ hashStruct(message)
    bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, hashStruct));

    // recover the address who signed the message with v, r, s
    address signer = ecrecover(digest, v, r, s);

    // perform message integrity and security validations
    require(signer != address(0), "invalid signature"); // Compound msg
    require(_nonce == nonces[signer], "invalid nonce"); // Compound msg
    require(block.timestamp < _exp, "signature expired"); // Compound msg

    // update the nonce for that particular signer to avoid replay attack
    nonces[signer]++;

    // delegate call to `__delegate` - execute the logic required
    __delegate(signer, _to);
  }