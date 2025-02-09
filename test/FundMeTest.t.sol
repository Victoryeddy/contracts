//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    DeployFundMe public deployFundMe;

    address public Funder = makeAddr("Alice");
    uint256 startingFunds = 1e18;

    function setUp() public {
       deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();
    }

    modifier userDeposit() {
        hoax(Funder, startingFunds);
        fundMe.deposit{value: startingFunds}();
        _;
    }

    function testUsersCanDepositFunds() public userDeposit {
        assertEq(address(fundMe).balance, startingFunds);
        assertEq(address(Funder).balance, 0);
    }

    function testUsersCanDepositFundsAndWithdraw() public userDeposit {
        vm.prank(Funder);
        fundMe.withdraw(startingFunds);

        assertEq(address(fundMe).balance, 0);
        assertEq(address(Funder).balance, startingFunds);
       
    }
}
