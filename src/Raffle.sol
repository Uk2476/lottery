//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Raffle is VRFConsumerBaseV2Plus {
    error notUpkeep();
    error insufficientEnterenceFee();
    error transactionFailed();

    bytes32 keyhash;
    bytes extraArgs;
    uint256 subId;
    uint16 public constant requestConfirmations = 5;
    uint32 callbackGasLimit;
    uint32 constant numWords = 1;
    uint256 public enteranceFee;
    uint256 public drawInterval;
    uint256 lastDrawTimeStamp;
    uint256 requestId;

    address payable[] private participantsAddresses;
    address payable public raffleWinner;

    constructor(
        uint256 _fee,
        uint256 _interval,
        bytes32 Keyhash,
        uint256 subscription,
        uint32 CallBackGasLimit,
        address vrfCoordinatorV2
    ) VRFConsumerBaseV2Plus(vrfCoordinatorV2) {
        enteranceFee = _fee;
        drawInterval = _interval;
        keyhash = Keyhash;
        subId = subscription;
        callbackGasLimit = CallBackGasLimit;
    }

    function enterRaffle() public payable {
        if (msg.value < enteranceFee) {
            revert insufficientEnterenceFee();
        }
        participantsAddresses.push(payable(msg.sender));
    }

    function checkUpkeep(bytes memory) public view returns (bool Upkeep, bytes memory) {
        bool interval = block.timestamp - lastDrawTimeStamp > drawInterval;
        bool players = participantsAddresses.length > 0;
        bool balance = address(this).balance > 0;
        Upkeep = interval && players && balance;
        return (Upkeep, "");
    }

    function performUpkeep() external {
        (bool check,) = checkUpkeep(bytes(""));

        if (!check) {
            revert notUpkeep();
        }

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: keyhash,
            subId: subId,
            requestConfirmations: requestConfirmations,
            callbackGasLimit: callbackGasLimit,
            numWords: numWords,
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
        });

        requestId = s_vrfCoordinator.requestRandomWords(request);

        lastDrawTimeStamp = block.timestamp;
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] calldata randomWords) internal override {
        uint256 noOfAccount = participantsAddresses.length;
        uint256 indexSelected = randomWords[0] % noOfAccount;
        raffleWinner = participantsAddresses[indexSelected];
        (bool success,) = raffleWinner.call{value: address(this).balance}("");
        if (!success) {
            revert transactionFailed();
        }

        lotteryRestart();
    }

    function lotteryRestart() internal {
        participantsAddresses = new address payable[](0);
    }
}
