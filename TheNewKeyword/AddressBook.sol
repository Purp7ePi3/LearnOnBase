// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    mapping(uint => Contact) private contacts;
    uint[] private contactIds;
    uint private nextId;

    error ContactNotFound(uint id);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function addContact(
        string memory _firstName,
        string memory _lastName,
        uint[] memory _phoneNumbers
    ) public onlyOwner {
        uint id = nextId++;
        contacts[id] = Contact(id, _firstName, _lastName, _phoneNumbers);
        contactIds.push(id);
    }

    function deleteContact(uint _id) public onlyOwner {
        if (contacts[_id].id != _id) revert ContactNotFound(_id);

        delete contacts[_id];
        for (uint i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }

    function getContact(uint _id) public view returns (Contact memory) {
        if (contacts[_id].id != _id) revert ContactNotFound(_id);
        return contacts[_id];
    }

    function getAllContacts() public view returns (Contact[] memory) {
        Contact[] memory result = new Contact[](contactIds.length);
        for (uint i = 0; i < contactIds.length; i++) {
            result[i] = contacts[contactIds[i]];
        }
        return result;
    }
}
