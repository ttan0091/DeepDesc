function replaceItemAddress(bytes32 id, address oneAddress, address anotherAddress) internal{
        require(!itemAddressExists(id,anotherAddress),"dup address added");
        for(uint256 i = 0; i < container[id].addresses.length; i++){
            if(container[id].addresses[i] == oneAddress){
                container[id].addresses[i] = anotherAddress;
                return;
            }
        }
        revert("not exist address");
    }