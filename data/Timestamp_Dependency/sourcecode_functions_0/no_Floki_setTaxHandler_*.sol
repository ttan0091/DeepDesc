function setTaxHandler(address taxHandlerAddress) external onlyOwner {
        address oldTaxHandlerAddress = address(taxHandler);
        taxHandler = ITaxHandler(taxHandlerAddress);

        emit TaxHandlerChanged(oldTaxHandlerAddress, taxHandlerAddress);
    }