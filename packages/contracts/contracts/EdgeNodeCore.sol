// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title EdgeNodeCore
 * @author BNB Edge Node OS — BNB Chain Ignite Hackathon 2026
 * @notice Consolidated DePIN + AI agent contract for opBNB Testnet.
 *         Handles node registration, on-chain reputation, time-based
 *         $EDGE reward minting, and gamified stats — all in one deploy.
 *
 * Architecture:
 *   - ERC-20 ($EDGE) minted on claimRewards() based on elapsed time
 *   - Node struct stores metadata, reputation, uptime, earnings
 *   - No external oracle needed: owner can simulate health updates
 *   - getPendingRewards() view lets frontend show real-time accrual
 *
 * Gas optimized for opBNB ($0.001/tx average).
 */
contract EdgeNodeCore is ERC20, Ownable {

    // ───────────────────── Structs ─────────────────────
    struct Node {
        bool     isActive;
        string   metadata;       // e.g. "RTX 4090 | USA | Grass+Theta"
        uint256  reputation;     // 0–1000 (100.0% = 1000)
        uint256  uptime;         // basis points: 10000 = 100.00%
        uint256  lastClaimTime;
        uint256  totalEarned;
        uint256  registeredAt;
    }

    // ───────────────────── State ───────────────────────
    mapping(address => Node) public nodes;
    address[] public nodeList;
    uint256 public totalActiveNodes;

    /// @notice 10 $EDGE per hour of active node time
    uint256 public constant REWARD_PER_HOUR = 10 * 10 ** 18;

    // ───────────────────── Events ──────────────────────
    event NodeRegistered(address indexed owner, string metadata, uint256 timestamp);
    event RewardsClaimed(address indexed owner, uint256 amount, uint256 timestamp);
    event NodeUpdated(address indexed owner, uint256 newReputation, uint256 newUptime);
    event NodeDeactivated(address indexed owner);

    // ───────────────────── Constructor ─────────────────
    constructor() ERC20("BNB Edge Token", "EDGE") Ownable(msg.sender) {
        // Mint 1000 EDGE to deployer for initial liquidity / demo
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    // ═══════════════════════════════════════════════════
    //                   CORE FUNCTIONS
    // ═══════════════════════════════════════════════════

    /**
     * @notice Register a new DePIN node on-chain.
     * @param _metadata Hardware/location descriptor (e.g. "RTX 4090 | Frankfurt")
     */
    function registerNode(string calldata _metadata) external {
        require(!nodes[msg.sender].isActive, "Already registered");

        nodes[msg.sender] = Node({
            isActive:      true,
            metadata:      _metadata,
            reputation:    950,        // Start high (95.0)
            uptime:        9800,       // Start at 98.00%
            lastClaimTime: block.timestamp,
            totalEarned:   0,
            registeredAt:  block.timestamp
        });

        nodeList.push(msg.sender);
        totalActiveNodes++;

        emit NodeRegistered(msg.sender, _metadata, block.timestamp);
    }

    /**
     * @notice Claim accumulated $EDGE rewards based on elapsed time.
     *         Follows Checks-Effects-Interactions (CEI) pattern.
     */
    function claimRewards() external {
        Node storage n = nodes[msg.sender];
        require(n.isActive, "Node not registered");

        uint256 elapsed = block.timestamp - n.lastClaimTime;
        require(elapsed > 0, "Nothing to claim");

        // reward = (elapsed_seconds × REWARD_PER_HOUR) / 3600
        uint256 reward = (elapsed * REWARD_PER_HOUR) / 3600;

        // Effects before interactions
        n.lastClaimTime = block.timestamp;
        n.totalEarned  += reward;

        // Mint $EDGE directly to the operator
        _mint(msg.sender, reward);

        emit RewardsClaimed(msg.sender, reward, block.timestamp);
    }

    // ═══════════════════════════════════════════════════
    //                   VIEW FUNCTIONS
    // ═══════════════════════════════════════════════════

    /**
     * @notice Preview pending rewards without claiming.
     */
    function getPendingRewards(address _node) external view returns (uint256) {
        Node storage n = nodes[_node];
        if (!n.isActive) return 0;
        uint256 elapsed = block.timestamp - n.lastClaimTime;
        return (elapsed * REWARD_PER_HOUR) / 3600;
    }

    /**
     * @notice Get total number of registered nodes.
     */
    function getTotalNodes() external view returns (uint256) {
        return nodeList.length;
    }

    /**
     * @notice Check if an address has an active node.
     */
    function isNodeActive(address _addr) external view returns (bool) {
        return nodes[_addr].isActive;
    }

    /**
     * @notice Get node details in one call (saves RPC round-trips).
     * @return isActive, reputation, uptime, totalEarned, registeredAt, metadata
     */
    function getNodeInfo(address _addr) external view returns (
        bool, uint256, uint256, uint256, uint256, string memory
    ) {
        Node storage n = nodes[_addr];
        return (n.isActive, n.reputation, n.uptime, n.totalEarned, n.registeredAt, n.metadata);
    }

    // ═══════════════════════════════════════════════════
    //               DEMO / ADMIN FUNCTIONS
    // ═══════════════════════════════════════════════════

    /**
     * @notice Owner can simulate AI agent health updates.
     *         In production → decentralized oracle / consensus.
     */
    function updateNodeHealth(
        address _node,
        uint256 _reputation,
        uint256 _uptime
    ) external onlyOwner {
        require(nodes[_node].isActive, "Node not found");
        require(_reputation <= 1000, "Rep max 1000");
        require(_uptime <= 10000, "Uptime max 10000");

        nodes[_node].reputation = _reputation;
        nodes[_node].uptime     = _uptime;

        emit NodeUpdated(_node, _reputation, _uptime);
    }

    /**
     * @notice Deactivate a node (self or owner).
     */
    function deactivateNode() external {
        require(nodes[msg.sender].isActive, "Not active");
        nodes[msg.sender].isActive = false;
        totalActiveNodes--;
        emit NodeDeactivated(msg.sender);
    }
}
