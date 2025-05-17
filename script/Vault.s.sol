// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";

import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function run() external {
        vm.startBroadcast();
        vault = new Vault(0xA1AB334dA781e7B22F16d951977114D9E467473B);
        vm.stopBroadcast();
    }
}
