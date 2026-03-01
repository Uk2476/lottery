//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Raffle {

    bytes32 keyhash;
    bytes extraArgs; 
    uint256 subId;
    uint16 public constant requestConfirmations = 5;
    uint32 callbackGasLimit;
    uint32 numWords ;
    uint256  public enteranceFee;
    uint256 public drawInterval ;
    uint256 lastDrawTimeStamp;


    address[] private payable participantsAddresses;

    constructor (uint256 _fee , uint256 _interval , bytes32 Keyhash , uint256 subsciption , uint32 CallBackGAsLimit) {
        enteranceFee = _fee;
        drawInterval = _interval;
    }

    function enterRaffle () public payable {
        require(msg.value > _fee , insufficientEnterenceFee());
        participantsAddress.push(msg.sender);
    }

    function pickWinner() external {
        if (block.timestamp - lastDrawTimestamp < drawInterval){
            revert intervalNotFinished();
        }

        
        VRFV2PlusClient request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: s_keyHash,
            subId: s_subscriptionId,
            requestConfirmations: requestConfirmations,
            callbackGasLimit: callbackGasLimit,
            numWords: numWords,
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            
        requestId = s_vrfCoordinator.requestRandomWords(request);

        lastDrawTimeStamp = block.timestamp;
    }
}