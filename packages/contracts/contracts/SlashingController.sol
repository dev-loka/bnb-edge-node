// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./WorkerRegistry.sol";
import "./StakingVault.sol";
import "./TimelockController.sol";

contract SlashingController is Ownable {
    WorkerRegistry public registry;
    StakingVault public vault;
    TimelockController public timelock;

    event SlashProposed(address indexed node, uint256 amount, string reason, bytes32 proposalId);
    event SlashExecuted(address indexed node, uint256 amount);

    constructor(address _registry, address _vault, address _timelock) Ownable(msg.sender) {
        registry = WorkerRegistry(payable(_registry));
        vault = StakingVault(_vault);
        timelock = TimelockController(payable(_timelock));
    }

    function proposeSlash(address node, uint256 amount, string memory reason) external onlyOwner {
        (, , uint256 stake, , , ) = registry.workers(node);
        require(stake >= amount, "Insufficient stake");
        bytes memory data = abi.encodeWithSelector(StakingVault.slash.selector, node, amount);
        bytes32 proposalId = timelock.hashOperation(address(vault), 0, data, bytes32(0), bytes32(0));
        timelock.schedule(address(vault), 0, data, bytes32(0), bytes32(0), timelock.getMinDelay());
        emit SlashProposed(node, amount, reason, proposalId);
    }

    function executeSlash(address node, uint256 amount) external {
        vault.slash(node, amount);
        emit SlashExecuted(node, amount);
    }
}
