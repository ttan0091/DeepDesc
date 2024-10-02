function enter(uint256 _amount) external {
    // Gets the amount of vader locked in the contract
    uint256 totalVader = vader.balanceOf(address(this));
    
    // Gets the amount of xVader in existence
    uint256 totalShares = totalSupply();
    
    uint256 xVADERToMint = totalShares == 0 || totalVader == 0
        ? _amount // If no xVader exists, mint it 1:1 with vader
        : (_amount * totalShares) / totalVader; // Calculate and mint the amount of xVader the vader is worth
    
    _mint(msg.sender, xVADERToMint); // Mint xVADER tokens to the sender
    vader.transferFrom(msg.sender, address(this), _amount); // Lock the vader in the contract
}