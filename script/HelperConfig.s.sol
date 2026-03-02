//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";

contract HelperConfig is Script {

    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;

    struct NetworkConfig{
        uint256 EnteranceFees;
        uint256 DrawIntervals;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callBackGasLimit;
        address vrfCoordinatorV2_5;       
    }

    NetworkConfig public networkconfig ;
    mapping ( uint256 => NetworkConfig ) public networkconfigs;

    constructor () {
        networkconfigs[SEPOLIA_CHAIN_ID]= getSepoliaConfig();
    }

    function getCONFIG(uint256 chainId) public view returns(NetworkConfig memory){
        return networkconfigs[chainId];
    }    

    function getSepoliaConfig() public pure returns(NetworkConfig memory) {
        return NetworkConfig({
            EnteranceFees: 0.01 ether,
            DrawIntervals: 30,
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            subscriptionId: 42468577630110820663695030829161487779629087988192532118338963736625030740319,              
            callBackGasLimit: 500000,
            vrfCoordinatorV2_5: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B
        });       
    }

}
