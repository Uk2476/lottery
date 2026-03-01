//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

contract Raffle {

    uint256  public enteranceFee;
    uint256 public drawInterval ;


    constructor (uint256 _fee , uint256 _interval) {
        enteranceFee = _fee;
        drawInterval = _interval;
    }

    function enterRaffle () public payable {
        require(msg.value > _fee , insufficientEnterenceFee())
    }

    function pickWinner() public {
        if (block.timestamp - lastDrawTimestamp < drawInterval){
            revert intervalNotFinished();
        }


        lastDrawTimeStamp = block.timestamp;
    }
}