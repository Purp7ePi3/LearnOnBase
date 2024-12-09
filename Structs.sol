// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GarageManager {

    // Define a custom error for bad car index
    error BadCarIndex(uint256 index);

    // Car struct definition
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    // Mapping from user address to their list of cars
    mapping(address => Car[]) public garage;

    // Function to add a car to the user's garage
    function addCar(
        string memory make,
        string memory model,
        string memory color,
        uint256 numberOfDoors
    ) public {
        // Create a new car instance
        Car memory newCar = Car(make, model, color, numberOfDoors);
        // Add the car to the garage for the caller
        garage[msg.sender].push(newCar);
    }

    // Function to get all cars owned by the caller
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Function to get all cars owned by any user
    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    // Function to update a car's details
    function updateCar(
        uint256 index,
        string memory make,
        string memory model,
        string memory color,
        uint256 numberOfDoors
    ) public {
        // Check if the index is valid for the sender
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }

        // Update the car at the given index
        Car storage carToUpdate = garage[msg.sender][index];
        carToUpdate.make = make;
        carToUpdate.model = model;
        carToUpdate.color = color;
        carToUpdate.numberOfDoors = numberOfDoors;
    }

    // Function to reset the caller's garage (delete all cars)
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
