function DOMAIN_SEPARATOR() internal view returns (bytes32) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        return
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                    keccak256(bytes(ERC20DetailedStorage.layout().name())),
                    keccak256("1"),
                    chainId,
                    address(this)
                )
            );
    }