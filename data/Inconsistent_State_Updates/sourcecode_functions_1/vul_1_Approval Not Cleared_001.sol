    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    interface IERC20 {
        function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
        function approve(address spender, uint256 amount) external returns (bool);
        function allowance(address owner, address spender) external view returns (uint256);
    }

    contract TokenTransfer {
        IERC20 public token;
        address public owner;
        mapping(address => bool) public approvedAddresses;

        constructor(address _token) {
            token = IERC20(_token);
            owner = msg.sender;
        }

        modifier onlyOwner() {
            require(msg.sender == owner, "Not the owner");
            _;
        }

        function approveAddress(address _addr) external onlyOwner {
            approvedAddresses[_addr] = true;
        }

        function transfer(address _to, uint256 _amount) external {
            require(approvedAddresses[msg.sender], "Not approved to transfer");

            // Transfer tokens
            require(token.transferFrom(msg.sender, _to, _amount), "Transfer failed");

        }
    }