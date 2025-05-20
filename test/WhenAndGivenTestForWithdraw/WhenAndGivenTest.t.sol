// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VaultTest} from "../Vault.t.sol";
import {Vault} from "../../src/Vault.sol";

contract WhenAndGivenTestForWithdraw is VaultTest {

    uint256 public constant approvAmount = 10000000000000000000000;
    uint256 public constant depAmount = 100000000000000000000;
    uint256 public constant withdrawnAmount = 10000000000000000000;
    
    event Withdrawn(address indexed user, uint256 amount);
    address sinclare = address(0x1);
    address sinclairee = address(0x2);

    function test_Given_amountIs0() external {
        // it should revert with ZeroNotAllowed
        vm.startPrank(sinc);
        vm.expectRevert(Vault.ZeroNotAllowed.selector);
        vault.withdraw(0);
        vm.stopPrank();
    }

    modifier given_amountGreaterThan0() {
        vm.startPrank(sinclare);
        sinclair.approve(address(vault), approvAmount);
        vault.deposit(depAmount);
        vault.withdraw(withdrawnAmount);
        vm.stopPrank;
        _;
       
    }

    function test_GivenBalancesOfMsgSenderLessThan_amount() external given_amountGreaterThan0 {
        // it should revert with InsufficientVaultBalance
         vm.startPrank(sinclare);
        vm.expectRevert(Vault.InsufficientVaultBalance.selector);
        vault.withdraw(depAmount + approvAmount);
        vm.stopPrank();
    }

    modifier givenBalancesOfMsgSenderGreaterThanOrEqualsTo_amount() {
        vm.startPrank(sinclare);
        vault.deposit(depAmount);
        vault.withdraw(depAmount);
        vm.stopPrank();
        _;
    }

    

    function test_GivenTransferSucceeds()
        external
        given_amountGreaterThan0
        givenBalancesOfMsgSenderGreaterThanOrEqualsTo_amount
    {
        // it should decrease balances of msg sender by _amount
        // it should decrease contractBalance by _amount
        // it should emit Withdrawn(msg sender, _amount)
         
        assertEq(vault.balances(sinc), depAmount - withdrawnAmount);
        assertEq(vault.contractBalance(), depAmount - withdrawnAmount);

        emit Vault.Withdrawn(sinc, withdrawnAmount);
        vm.stopPrank();
        
    }
}
