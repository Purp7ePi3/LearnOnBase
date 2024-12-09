// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FavoriteRecords {
    // Custom error for unapproved records
    error NotApproved(string albumName);

    // Mapping to track approved records
    mapping(string => bool) public approvedRecords;

    // Nested mapping to track user favorites
    mapping(address => mapping(string => bool)) public userFavorites;

    // Array to keep track of approved record names for retrieval
    string[] private approvedRecordNames;

    // Constructor to load approved records
    constructor() {
        string[9] memory records = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        // Load approved records
        for (uint i = 0; i < records.length; i++) {
            approvedRecords[records[i]] = true;
            approvedRecordNames.push(records[i]);
        }
    }

    // Function to get all approved records
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordNames;
    }

    // Function to add a record to user's favorites
    function addRecord(string memory _albumName) public {
        // Check if the album is approved
        if (!approvedRecords[_albumName]) {
            revert NotApproved(_albumName);
        }

        // Add the record to user's favorites
        userFavorites[msg.sender][_albumName] = true;
    }

    // Function to get a user's favorite records
    function getUserFavorites(address _user) public view returns (string[] memory) {
        // Create a temporary array to store favorites
        string[] memory favorites = new string[](approvedRecordNames.length);
        uint count = 0;

        // Iterate through approved records to find user's favorites
        for (uint i = 0; i < approvedRecordNames.length; i++) {
            if (userFavorites[_user][approvedRecordNames[i]]) {
                favorites[count] = approvedRecordNames[i];
                count++;
            }
        }

        // Resize the array to the actual number of favorites
        assembly {
            mstore(favorites, count)
        }

        return favorites;
    }

    // Function to reset user's favorites
    function resetUserFavorites() public {
        // Iterate through approved records to reset
        for (uint i = 0; i < approvedRecordNames.length; i++) {
            userFavorites[msg.sender][approvedRecordNames[i]] = false;
        }
    }
}