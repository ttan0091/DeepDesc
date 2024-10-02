function isMain() public view returns (bool) {
        if (now > dateMainStart && now < dateMainEnd) return true;
        return false;
    }