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

    address sinc = address(0x1);
    address sinc2 = address(0x2);

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
}
