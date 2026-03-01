//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

contract Raffle {

    uint256  public enteranceFee;
    uint256 public drawInterval ;

    address[] private participantsAddresses;

    constructor (uint256 _fee , uint256 _interval) {
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

        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            


        lastDrawTimeStamp = block.timestamp;
    }
}