// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AgentRegistry is ERC721, Ownable {
    uint256 private _nextId = 1;
    mapping(uint256 => uint256) public capabilities; // Bitmask
    mapping(uint256 => uint256) public reputation; // EMA score scaled x100

    event AgentCreated(uint256 indexed id, address owner, uint256 capabilities);

    constructor() ERC721("BEdgeAgent", "BEAGENT") Ownable(msg.sender) {}

    function createAgent(uint256 capabilityBitmask) external {
        uint256 id = _nextId++;
        _safeMint(msg.sender, id);
        capabilities[id] = capabilityBitmask;
        reputation[id] = 1000; // 10.00
        emit AgentCreated(id, msg.sender, capabilityBitmask);
    }

    function updateReputation(uint256 id, uint256 newRep) external onlyOwner {
        reputation[id] = newRep;
    }
}
