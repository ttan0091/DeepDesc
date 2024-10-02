function getNewBurnStatusId(bool newBurnStatus, int nonce)
        public
        pure
        returns (bytes32 result)
    {
        result =
            keccak256(
                abi.encode(
                    0xB012,
                    newBurnStatus,
                    nonce
                )
            );
    }