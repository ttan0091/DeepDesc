function permit(
        address holder, address spender, uint256 nonce, uint256 expiry,
        bool allowed, uint8 v, bytes32 r, bytes32 s) external {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        holder,
                        spender,
                        nonce,
                        expiry,
                        allowed
                    )
                )
            )
        );

        require(holder != address(0), "Ngnt/invalid-address-0");
        require(holder == ecrecover(digest, v, r, s), "Ngnt/invalid-permit");
        require(expiry == 0 || now <= expiry, "Ngnt/permit-expired");
        require(nonce == nonces[holder]++, "Ngnt/invalid-nonce");
        uint wad = allowed ? uint(- 1) : 0;
        _approve(holder, spender, wad);
    }