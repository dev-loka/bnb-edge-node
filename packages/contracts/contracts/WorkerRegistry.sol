// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/IPFS.sol";
import "./SlashingController.sol";

contract WorkerRegistry is Ownable {
    struct Node {
        string nodeType;
        string ipfsSpecCID; // IPFS CID for hardware spec
        uint256 stake;
        uint256 reputation; // EMA-based
        uint256 lastHeartbeat;
        bool slashed;
    }

    mapping(address => Node) public nodes;
    SlashingController public slashing;

    event NodeRegistered(address indexed owner, string nodeType, string ipfsCID);
    event Heartbeat(address indexed owner, uint256 timestamp);

    constructor(address _slashing) Ownable(msg.sender) {
        slashing = SlashingController(_slashing);
    }

    function registerNode(string memory nodeType, string memory ipfsSpecCID, uint256 stakeAmount) external payable {
        require(msg.value == stakeAmount, "Incorrect stake");
        require(nodes[msg.sender].stake == 0, "Already registered");
        nodes[msg.sender] = Node({
            nodeType: nodeType,
            ipfsSpecCID: ipfsSpecCID,
            stake: stakeAmount,
            reputation: 1000, // 10.00 scaled
            lastHeartbeat: block.timestamp,
            slashed: false
        });
        emit NodeRegistered(msg.sender, nodeType, ipfsSpecCID);
    }

    function heartbeat() external {
        require(nodes[msg.sender].stake > 0, "Not registered");
        require(!nodes[msg.sender].slashed, "Slashed");
        nodes[msg.sender].lastHeartbeat = block.timestamp;
        // Update EMA reputation
        nodes[msg.sender].reputation = (nodes[msg.sender].reputation * 95 / 100) + (1000 * 5 / 100); // Simple EMA
        emit Heartbeat(msg.sender, block.timestamp);
    }

    function slash(address node) external {
        require(msg.sender == address(slashing), "Only slashing");
        nodes[node].slashed = true;
    }
}
