// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// Importing the SillyStringUtils library
library SillyStringUtils {
    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}

contract ImportsExercise {
    // Using the imported library
    using SillyStringUtils for *;

    // Public instance of Haiku
    SillyStringUtils.Haiku public haiku;

    // Save Haiku function
    function saveHaiku(string memory line1, string memory line2, string memory line3) public {
        haiku.line1 = line1;
        haiku.line2 = line2;
        haiku.line3 = line3;
    }

    // Get Haiku function
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // Shruggie Haiku function (return new Haiku with shruggie only on the third line)
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        // Create a new Haiku struct
        SillyStringUtils.Haiku memory newHaiku;

        // Copy the first two lines from the original haiku
        newHaiku.line1 = haiku.line1;
        newHaiku.line2 = haiku.line2;

        // Apply shruggie only to the third line and set it in the new haiku
        newHaiku.line3 = SillyStringUtils.shruggie(haiku.line3);

        // Return the new haiku
        return newHaiku;
    }
}
