function compoundingAPY(uint pid, uint compoundUnit) 
    view 
    public 
    returns (uint) 
{
    uint __apy = _apy(pid);
    uint compoundTimes = 365 days / compoundUnit;
    uint unitAPY = 1e18 + (__apy / compoundTimes);
    uint result = 1e18;

    for(uint i = 0; i < compoundTimes; i++) {
        result = (result * unitAPY) / 1e18;
    }

    return result - 1e18;
}