function removeMinter(address minter_address) external onlyByOwnGov {
        require(minter_address != address(0), "Zero address detected");
        require(minters[minter_address] == true, "Address nonexistant");
        
        // Delete from the mapping
        delete minters[minter_address];

        // 'Delete' from the array by setting the address to 0x0
        for (uint i = 0; i < minters_array.length; i++){ 
            if (minters_array[i] == minter_address) {
                minters_array[i] = address(0); // This will leave a null in the array and keep the indices the same
                break;
            }
        }

        emit MinterRemoved(minter_address);
    }