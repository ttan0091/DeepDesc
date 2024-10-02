function removeOneItemAddress(bytes32 id, address oneAddress) internal{
        for(uint256 i = 0; i < container[id].addresses.length; i++){
            if(container[id].addresses[i] == oneAddress){
                container[id].addresses[i] = container[id].addresses[container[id].addresses.length - 1];
                container[id].addresses.length--;
                return;
            }
        }
        revert("not exist address");
    }