// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";

import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function run() external {
        vm.startBroadcast();
        vault = new Vault(0x3F2ce71A3e46d57C89ECDE315D7b382CE20D600a);
        vm.stopBroadcast();
    }
}
