function initAdmin(address owner0, address owner1, address owner2) internal{
        addItemAddress(OWNERHASH, owner0);
        addItemAddress(OWNERHASH, owner1);
        addItemAddress(OWNERHASH, owner2);
        addItemAddress(LOGICHASH, address(0x0));
        addItemAddress(STOREHASH, address(0x1));

        classHashArray.push(OWNERHASH);
        classHashArray.push(OPERATORHASH);
        classHashArray.push(PAUSERHASH);
        classHashArray.push(STOREHASH);
        classHashArray.push(LOGICHASH);
        ownerRequireNum = 2;
        operatorRequireNum = 2;
    }