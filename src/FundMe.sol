//SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract FundMe is ReentrancyGuard {
    mapping(address => uint256) public s_balances;

    address payable[] public s_funders;
    mapping(address => bool) private s_uniqueFunders;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    error FundMe_DepositTooSmall(uint256 amountSent);
    error FundMe_InsufficientFunds(uint256 balanceOfSender, uint256 amountToWithdraw);

    function deposit() public payable {
        if (msg.value < 0) revert FundMe_DepositTooSmall({amountSent: msg.value});

        s_balances[msg.sender] += msg.value;

        if (!s_uniqueFunders[msg.sender]) {
            s_funders.push(payable(msg.sender));
            s_uniqueFunders[msg.sender] = true;
        }

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external nonReentrant {
        if (s_balances[msg.sender] < amount) revert FundMe_InsufficientFunds(s_balances[msg.sender], amount);
        s_balances[msg.sender] -= amount;

        if (s_balances[msg.sender] == 0) {
            s_uniqueFunders[msg.sender] = false;
        }

        (bool success,) = payable(msg.sender).call{value: amount}("");
        if (!success) revert();
        emit Withdrawal(msg.sender, amount);
    }

    // Helper Functions
    function getFundersCount() external view returns (uint256) {
        return s_funders.length;
    }

    function getTotalBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        deposit();
    }

}
