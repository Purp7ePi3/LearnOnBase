// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeStorage {
    // Custom error for too many shares
    error TooManyShares(uint256 totalShares);

    // Packed storage variables
    uint16 private shares;
    uint16 private idNumber16;  // First 16 bits of idNumber
    uint32 private idNumberRest;  // Remaining bits of idNumber
    uint104 private salary;
    
    // Public name variable as a string
    string public name;

    // Constructor to initialize all state variables
    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50000;
        
        // Split idNumber into two parts for packing
        idNumber16 = uint16(112358132134 >> 32);
        idNumberRest = uint32(112358132134 & 0xFFFFFFFF);
    }

    // Function to reconstruct full idNumber
    function idNumber() public view returns (uint256) {
        return (uint256(idNumber16) << 32) | idNumberRest;
    }

    // Function to view salary
    function viewSalary() public view returns (uint104) {
        return salary;
    }

    // Function to view shares
    function viewShares() public view returns (uint16) {
        return shares;
    }

    // Function to grant additional shares
    function grantShares(uint16 _newShares) public {
        // Revert if new shares would exceed 5000
        if (_newShares > 5000 || shares + _newShares > 5000) {
            revert("Too many shares");
        }

        // Add new shares
        shares += _newShares;
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}
