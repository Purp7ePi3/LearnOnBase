// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {

    uint256 constant MAX_INT = type(uint256).max;  // Maximum value for uint256

    // Function to add two numbers and handle overflow
    function adder(uint256 _a, uint256 _b) public pure returns (uint256 sum, bool error) {
        // Special case: check if adding 1 to MAX_INT
        if (_a == 1 && _b == MAX_INT) {
            return (0, true);  // Overflow occurred, specific case
        }
        
        // General overflow check
        if (_a + _b < _a) {
            return (0, true);  // Overflow occurred
        }

        return (_a + _b, false);  // No overflow
    }

    // Function to subtract two numbers and handle underflow
    function subtractor(uint256 _a, uint256 _b) public pure returns (uint256 difference, bool error) {
        // Check for underflow
        if (_a < _b) {
            return (0, true);  // Underflow occurred
        }
        return (_a - _b, false);  // No underflow
    }
}