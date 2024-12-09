// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArraysExercise {
    // Initial numbers array
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    // Arrays to track senders and timestamps
    address[] public senders;
    uint[] public timestamps;

    // Function to return the entire numbers array
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    // Function to reset numbers array to original state
    function resetNumbers() public {
        // Efficiently reset without using push
        assembly {
            // Clear the array
            sstore(numbers.slot, 0)
        }
        // Recreate the initial array
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    // Function to append an array to numbers
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Function to save timestamp and sender
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Function to filter timestamps after Y2K
    function afterY2K() public view returns (uint[] memory, address[] memory) {
        // Count matching timestamps
        uint count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                count++;
            }
        }

        // Create arrays to store matching timestamps and senders
        uint[] memory filteredTimestamps = new uint[](count);
        address[] memory filteredSenders = new address[](count);

        // Populate filtered arrays
        uint j = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                filteredTimestamps[j] = timestamps[i];
                filteredSenders[j] = senders[i];
                j++;
            }
        }

        return (filteredTimestamps, filteredSenders);
    }

    // Function to reset senders array
    function resetSenders() public {
        delete senders;
    }

    // Function to reset timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }
}