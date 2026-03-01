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
    VRFV2PlusClient requestId;


    address[] private payable participantsAddresses;
    address public payable raffleWinner ;

    constructor (uint256 _fee , uint256 _interval , bytes32 Keyhash , uint256 subsciption , uint32 CallBackGasLimit , address vrfCoordinatorV2 ) VRFConsumerBaseV2Plus(vrfCoordinatorV2) {
        enteranceFee = _fee;
        drawInterval = _interval;
        keyhash = Keyhash ;
        subId = subscription;
        callbackGasLimit = CallBackGasLimit ;

    }

    function enterRaffle () public payable {
        require(msg.value > _fee , insufficientEnterenceFee());
        participantsAddress.push(payable(msg.sender));
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
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))})
            
        requestId = s_vrfCoordinator.requestRandomWords(request);

        lastDrawTimeStamp = block.timestamp;
    }

    function fulfillRandomWords(uint256 requestid, uint256[] memory randomWords) internal override{
        uint256 memory noOfAccount = participantsAddress.length ;
        uint256 memory indexSelected = randomWords[0]%noOfAccount ;
        raffleWinner = participantsAddresses[indexSelected];
        (bool success,)= raffleWinner.call{value: address(this).balance}("");
        require(success , transactionFailed());

        lotteryRestart();
    }

    function lotteryRestart() internal {
        participantsAddresses = new address payable [](0);
    }
}