// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    uint[] arr;

    function abs(int x) internal pure returns (uint) {
        return uint(x >= 0 ? x : -x);
    }

    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        results[0] = abs(int(_a) - int(_b));
        results[1] = abs(int(_b) - int(_c));
        results[2] = abs(int(_c) - int(_d));

        return results;
    }

    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        require(_base >= 1000, "Base must be >= 1000");
        require(_modifier >= -100 && _modifier <= 100, "Modifier out of range");

        int result = int(_base) + _modifier;
        require(result >= 0, "Result below zero");

        return uint(result);
    }

    function popWithReturn() public returns (uint) {
        require(arr.length > 0, "Array is empty");
        uint value = arr[arr.length - 1];
        arr.pop();
        return value;
    }

    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
