//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {Script, console2} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig{
        uint256 EnteranceFees;
        uint256 DrawIntervals;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callBackGasLimit;
        address vrfCoordinatorV2_5;       
    }
}
