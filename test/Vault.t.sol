// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

import {Sinclair} from "../src/ERC20.sol";

contract VaultTest is Test {
    Vault public vault;
    Sinclair public sinclair;

    uint256 public constant approveAmount = 10000000000000000000000;
    uint256 public constant depositAmount = 100000000000000000000;
    uint256 public constant withdrawAmount = 10000000000000000000;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    address sinc = address(0x1);
    address sinc2 = address(0x2);

    modifier approveAndDeposit() {
        vm.startPrank(sinc);
        sinclair.approve(address(vault), approveAmount);
        vault.deposit(depositAmount);
        vm.stopPrank;
        _;
    }

    modifier approveAndDeposit2() {
        vm.startPrank(sinc2);
        sinclair.approve(address(vault), approveAmount);
        vault.deposit(depositAmount);
        vm.stopPrank;
        _;
    }

    function setUp() external {
        sinclair = new Sinclair(address(this));
        vm.startPrank(sinc2);

        sinclair.unRestrictedMint(sinc2, 100000000000 * 10 ** 18);
        vm.stopPrank();

        vm.startPrank(sinc);

        sinclair.unRestrictedMint(sinc, 100000000000 * 10 ** 18);
        vm.stopPrank();

        // vault = new Vault(0x3F2ce71A3e46d57C89ECDE315D7b382CE20D600a);
        vault = new Vault(address(sinclair));
        uint256 balance = sinclair.balanceOf(sinc);
        console.log("sinc Balance:", balance);

        uint256 balance2 = sinclair.balanceOf(sinc2);
        console.log("sinc2 Balance:", balance2);
    }

    function testDepositSuccess() public approveAndDeposit {
        // Should deposit tokens successfully
        vm.startPrank(sinc);

        assertEq(vault.balances(sinc), depositAmount);
        assertEq(vault.contractBalance(), depositAmount);

        emit Vault.Deposited(sinc, depositAmount);
        vm.stopPrank();
    }

    function testDepositZeroReverts() public {
        vm.startPrank(sinc);
        vm.expectRevert(Vault.ZeroNotAllowed.selector);
        vault.deposit(0);
        vm.stopPrank();
    }

    function testDepositWithoutApprovalReverts() public {
        vm.startPrank(sinc);
        vm.expectRevert(Vault.InsufficientAllowance.selector);
        vault.deposit(100000);
        vm.stopPrank();
    }

    function testDepositInsufficientApprovalReverts() public {
        // Should revert if approved amount is less than deposit
        vm.startPrank(sinc);
        sinclair.approve(address(this), 100000);
        vm.expectRevert(Vault.InsufficientAllowance.selector);
        vault.deposit(10000000);
        vm.stopPrank();
    }

    function testWithdrawSuccess() public approveAndDeposit {
        // Should withdraw deposited tokens successfully
        vm.startPrank(sinc);
        vault.withdraw(withdrawAmount);
        assertEq(vault.balances(sinc), depositAmount - withdrawAmount);
        assertEq(vault.contractBalance(), depositAmount - withdrawAmount);

        emit Vault.Withdrawn(sinc, withdrawAmount);
        vm.stopPrank();
    }

    function testWithdrawZeroReverts() public {
        // Should revert when withdrawal amount is zero
        vm.startPrank(sinc);
        vm.expectRevert(Vault.ZeroNotAllowed.selector);
        vault.withdraw(0);
        vm.stopPrank();
    }

    function testWithdrawMoreThanBalanceReverts() public approveAndDeposit {
        // Should revert when withdrawing more than deposited
        vm.startPrank(sinc);
        vm.expectRevert(Vault.InsufficientVaultBalance.selector);
        vault.withdraw(depositAmount + approveAmount);
        vm.stopPrank();
    }

    function testMultipleDepositsAccumulateCorrectly() public approveAndDeposit approveAndDeposit2 {
        // Repeated deposits by one user should be cumulative
        assertEq(vault.balances(sinc), depositAmount);
        assertEq(vault.balances(sinc2), depositAmount);
        assertEq(vault.contractBalance(), depositAmount * 2);
    }

    function testMultipleUsersTrackedIndependently() public approveAndDeposit approveAndDeposit2 {
        // Separate users can deposit/withdraw independently
        vm.startPrank(sinc);
        vault.withdraw(withdrawAmount);
        emit Vault.Withdrawn(sinc, withdrawAmount);
        vm.stopPrank();

        vm.startPrank(sinc2);
        vault.withdraw(withdrawAmount);
        emit Vault.Withdrawn(sinc2, withdrawAmount);
        vm.stopPrank();

        assertEq(vault.balances(sinc), depositAmount - withdrawAmount);
        assertEq(vault.balances(sinc2), depositAmount - withdrawAmount);
        assertEq(vault.contractBalance(), 2 * (depositAmount - withdrawAmount));
    }
}
