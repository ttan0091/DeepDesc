function changeDCRMOwner(address newOwner) public onlyOwner returns (bool) {
        require(newOwner != address(0), "new owner is the zero address");
        _oldOwner = owner();
        _newOwner = newOwner;
        _newOwnerEffectiveTime = block.timestamp + 2*24*3600;
        emit LogChangeDCRMOwner(_oldOwner, _newOwner, _newOwnerEffectiveTime);
        return true;
    }