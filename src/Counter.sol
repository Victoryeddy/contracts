// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public s_number;

    function setNumber(uint256 newNumber) public {
        s_number = newNumber;
    }

    function increment() public {
        s_number++;
    }
}
