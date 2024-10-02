function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        super._beforeTokenTransfer(from, to, amount);

        if (from == address(0)) {
            // When minting tokens
            require(totalMinted().add(amount) <= cap(), "ERC20Capped: cap exceeded");
        }
    }