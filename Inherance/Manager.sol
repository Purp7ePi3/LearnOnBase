// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Manager {
    uint[] public employeeIds;

    function addReport(uint _idNumber) public {
        employeeIds.push(_idNumber);
    }

    function resetReports() public {
        delete employeeIds;
    }
}

