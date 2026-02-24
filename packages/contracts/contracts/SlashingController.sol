// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./WorkerRegistry.sol";
import "./StakingVault.sol";
import "./TimelockController.sol";

contract SlashingController is Ownable {
    WorkerRegistry public registry;
    StakingVault public vault;
    TimelockController public timelock;

    event SlashProposed(address indexed node, uint256 amount, string reason, uint256 proposalId);
    event SlashExecuted(address indexed node, uint256 amount);

    constructor(address _registry, address _vault, address _timelock) Ownable(msg.sender) {
        registry = WorkerRegistry(_registry);
        vault = StakingVault(_vault);
        timelock = TimelockController(payable(_timelock));
    }

    function proposeSlash(address node, uint256 amount, string memory reason) external onlyOwner {
        (, , uint256 stake, , , ) = registry.nodes(node);
        require(stake >= amount, "Insufficient stake");
        bytes memory data = abi.encodeWithSelector(WorkerRegistry.slash.selector, node);
        uint256 proposalId = timelock.hashOperation(address(registry), 0, data, bytes32(0), bytes32(0));
        timelock.schedule(address(registry), 0, data, bytes32(0), bytes32(0), timelock.getMinDelay());
        emit SlashProposed(node, amount, reason, proposalId);
    }

    function executeSlash(address node) external {
        registry.slash(node);
        (, , uint256 amount, , , ) = registry.nodes(node);
        vault.slash(node, amount);
        emit SlashExecuted(node, amount);
    }
}
