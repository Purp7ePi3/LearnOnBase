// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnburnableToken {
    // Mapping to track token balances for each address
    mapping(address => uint) public balances;
    
    // Total supply of tokens
    uint public totalSupply;
    
    // Total number of tokens claimed
    uint public totalClaimed;
    
    // Tracking which addresses have already claimed tokens
    mapping(address => bool) private hasClaimed;
    
    // Custom error for when tokens have already been claimed by an address
    error TokensClaimed();
    
    // Custom error for when all tokens have been claimed
    error AllTokensClaimed();
    
    // Custom error for unsafe transfer
    error UnsafeTransfer(address recipient);

    // Constructor to set total supply
    constructor() {
        totalSupply = 100_000_000;
    }

    // Claim function allowing one-time token claim
    function claim() public {
        // Check if the address has already claimed tokens
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        
        // Check if all tokens have been claimed
        if (totalClaimed + 1000 > totalSupply) {
            revert AllTokensClaimed();
        }
        
        // Mark this address as having claimed
        hasClaimed[msg.sender] = true;
        
        // Update balances
        balances[msg.sender] += 1000;
        
        // Increment total claimed tokens
        totalClaimed += 1000;
    }

    // Safe transfer function with additional checks
    function safeTransfer(address _to, uint _amount) public {
        // Check for zero address
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }
        
        // Check recipient's ETH balance
        if (_to.balance == 0) {
            revert UnsafeTransfer(_to);
        }
        
        // Check sender's token balance
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        // Perform transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}