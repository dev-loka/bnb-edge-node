// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WorkerRegistry.sol";

contract StakingVault is Ownable {
    IERC20 public stakingToken;
    WorkerRegistry public registry;

    struct Stake {
        uint256 amount;
        uint256 unlockTime; // 7-day cooldown
        uint256 lastEpochClaimed;
    }

    mapping(address => Stake) public stakes;
    uint256 public constant COOLDOWN_PERIOD = 7 days;
    uint256 public constant APY = 8800; // 88% scaled x100
    uint256 public constant EPOCH_DURATION = 1 days;

    event Staked(address indexed user, uint256 amount);
    event UnstakeRequested(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _token, address _registry) Ownable(msg.sender) {
        stakingToken = IERC20(_token);
        registry = WorkerRegistry(_registry);
    }

    function stake(uint256 amount) external {
        stakingToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender].amount += amount;
        emit Staked(msg.sender, amount);
    }

    function requestUnstake(uint256 amount) external {
        require(stakes[msg.sender].amount >= amount, "Insufficient stake");
        stakes[msg.sender].amount -= amount;
        stakes[msg.sender].unlockTime = block.timestamp + COOLDOWN_PERIOD;
        emit UnstakeRequested(msg.sender, amount);
    }

    function withdraw() external {
        require(block.timestamp >= stakes[msg.sender].unlockTime, "Cooldown active");
        uint256 amount = stakes[msg.sender].amount;
        stakes[msg.sender].amount = 0;
        stakingToken.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function claimRewards() external {
        uint256 currentEpoch = block.timestamp / EPOCH_DURATION;
        require(currentEpoch > stakes[msg.sender].lastEpochClaimed, "Already claimed");
        uint256 epochs = currentEpoch - stakes[msg.sender].lastEpochClaimed;
        uint256 rep = registry.nodes[msg.sender].reputation;
        uint256 baseReward = (stakes[msg.sender].amount * APY / 10000 * epochs) / 365;
        uint256 adjusted = baseReward * rep / 1000; // rep scaled
        stakingToken.transfer(msg.sender, adjusted);
        stakes[msg.sender].lastEpochClaimed = currentEpoch;
    }

    function slash(address user, uint256 amount) external {
        require(msg.sender == address(registry.slashing()), "Only slashing controller");
        require(stakes[user].amount >= amount, "Amount exceeds stake");
        stakes[user].amount -= amount;
        stakingToken.transfer(msg.sender, amount);
    }
}
