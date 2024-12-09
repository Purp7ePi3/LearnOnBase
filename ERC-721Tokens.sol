// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HaikuNFT is ERC721, Ownable(msg.sender) {
    error HaikuNotUnique();
    error NotYourHaiku(uint256 id);
    error NoHaikusShared();

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    mapping(string => bool) public usedLines;
    uint256 public counter = 1;

    constructor() ERC721("HaikuNFT", "HAIKU") {}

    function mintHaiku(string memory _line1, string memory _line2, string memory _line3) external {
        if (usedLines[_line1] || usedLines[_line2] || usedLines[_line3]) {
            revert HaikuNotUnique();
        }

        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        haikus.push(Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        }));

        _safeMint(msg.sender, counter);
        counter++;
    }

    function shareHaiku(uint256 _id, address _to) public {
        if (ownerOf(_id) != msg.sender) {
            revert NotYourHaiku(_id);
        }

        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory sharedHaikuIds = sharedHaikus[msg.sender];
        
        if (sharedHaikuIds.length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory mySharedHaikus = new Haiku[](sharedHaikuIds.length);
        for (uint256 i = 0; i < sharedHaikuIds.length; i++) {
            mySharedHaikus[i] = haikus[sharedHaikuIds[i] - 1];
        }

        return mySharedHaikus;
    }
}