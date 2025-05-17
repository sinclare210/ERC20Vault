// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";

import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function run() external {
        vm.startBroadcast();
        vault = new Vault(0x4CD275b1c9e1F2d4C10E08bBC6D8b34fC38Dc62a);
        vm.stopBroadcast();
    }
}
