//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle){
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getCONFIG();

        Raffle raffle;
        vm.startBroadcast();
        raffle = new Raffle(
            config.EnteranceFees,
            config.DrawIntervals,
            config.gasLane,
            config.subscriptionId,
            config.callBackGasLimit,
            config.vrfCoordinatorV2_5
        );
        vm.stopBroadcast();
    }
}
