// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VaultTest} from "../Vault.t.sol";
import {Vault} from "../../src/Vault.sol";

contract WhenAndGivenTestForDeposit is VaultTest{

    
    uint256 public constant approvAmount = 10000000000000000000000;
    uint256 public constant depAmount = 100000000000000000000;
    uint256 public constant withdrawnAmount = 10000000000000000000;
    event Deposited(address indexed user, uint256 amount);
    address sinclare = address(0x1);
    address sinclairee = address(0x2);

    function test_Given_amountIs0() external {
        // it should revert with ZeroNotAllowed
        vm.startPrank(sinclare);
        vm.expectRevert(Vault.ZeroNotAllowed.selector);
        vault.deposit(0);
        vm.stopPrank();
    }

    modifier given_amountGreaterThan0() {
        vm.startPrank(sinclare);
        sinclair.approve(address(vault), approvAmount);
        vault.deposit(depositAmount);
        vm.stopPrank;
        _;
    }

    

    function test_GivenTransferFromSucceeds() external given_amountGreaterThan0 {
        // it should increase balances of msg.sender by _amount
        // it should increase contractBalance by _amount
        // it should emit Deposited(msg.sender, _amount)
        vm.startPrank(sinclare);

        assertEq(vault.balances(sinclare), depAmount);
        assertEq(vault.contractBalance(), depAmount);

        emit Vault.Deposited(sinc, depAmount);
        vm.stopPrank();
    }
}
