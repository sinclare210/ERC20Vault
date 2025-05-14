// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";

import {Sinclair} from "../src/ERC20.sol";

contract ERC20Script is Script{
    Sinclair public sinclair;
    function run() external{
        vm.startBroadcast();
        sinclair = new Sinclair(msg.sender);
        vm.stopBroadcast();
    }

}
