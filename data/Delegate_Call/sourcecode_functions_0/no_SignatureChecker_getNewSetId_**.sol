function getNewSetId(int oracleSetHash, address[] memory set)
        public
        pure
        returns (bytes32 result)
    {
        result = 
            keccak256(
                abi.encode(
                    0x5e7,
                    oracleSetHash,
                    set                    
                )
            );
    }