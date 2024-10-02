function burnAsset(address asset, uint256 amount) public isLive incrementFate {
    require(assetApproved[asset], "LimboDAO: illegal asset");
    address sender = _msgSender();
    require(ERC677(asset).transferFrom(sender, address(this), amount), "LimboDAO: transferFailed");
    
    uint256 fateCreated = fateState[_msgSender()].fateBalance;
    if (asset == domainConfig.eye) {
        fateCreated = amount * 10;
        ERC677(domainConfig.eye).burn(amount);
    } else {
        uint256 actualEyeBalance = IERC20(domainConfig.eye).balanceOf(asset);
        require(actualEyeBalance > 0, "LimboDAO: No EYE");
        uint256 totalSupply = IERC20(asset).totalSupply();
        uint256 eyePerUnit = (actualEyeBalance * ONE) / totalSupply;
        uint256 impliedEye = (eyePerUnit * amount) / ONE;
        fateCreated = impliedEye * 20;
    }
    
    fateState[_msgSender()].fateBalance += fateCreated;
    emit assetBurnt(_msgSender(), asset, fateCreated);
}