// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EmissionController.sol";
import "./RewardVault.sol";

contract EpochManager is Ownable {
    EmissionController public emissions;
    RewardVault public rewards;
    uint256 public currentEpoch = 0;
    uint256 public epochDuration = 1 days;
    uint256 public lastEpochTime;

    event EpochAdvanced(uint256 indexed epoch, uint256 timestamp);

    constructor(address _emissions, address _rewards) Ownable(msg.sender) {
        emissions = EmissionController(_emissions);
        rewards = RewardVault(_rewards);
        lastEpochTime = block.timestamp;
    }

    function advanceEpoch() external {
        require(block.timestamp >= lastEpochTime + epochDuration, "Epoch not ready");
        currentEpoch++;
        lastEpochTime = block.timestamp;
        // Trigger emission distribution
        emissions.checkHalving();
        // Submit to rewards (placeholder for Merkle root)
        emit EpochAdvanced(currentEpoch, block.timestamp);
    }

    function setEpochDuration(uint256 newDuration) external onlyOwner {
        epochDuration = newDuration;
    }
}
