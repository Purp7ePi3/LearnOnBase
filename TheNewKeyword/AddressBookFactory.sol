//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./AddressBook.sol";

contract AddressBookFactory {
    event ContractDeployed(address indexed contractAddress);

    function deploy() public returns (address) {
        AddressBook newAddressBook = new AddressBook(msg.sender);
        emit ContractDeployed(address(newAddressBook));
        return address(newAddressBook);
    }
}
