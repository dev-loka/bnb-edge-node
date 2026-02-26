// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WorkerRegistry is Ownable {
    struct Worker {
        address worker;
        uint256 stake;          // in wei (BNB)
        uint256 reputation;
        uint256 registrationTime;
        bool active;
        string metadata;
    }

    mapping(address => Worker) public workers;
    address[] public workerList;
    uint256 public totalStaked;

    // Multiplier parameters (basis points, 100 = 1.00x)
    uint256 public baseMultiplier = 100;
    uint256 public stakeWeight = 10;      // per full BNB
    uint256 public timeWeight = 5;        // per day
    uint256 public repWeight = 20;        // per reputation point

    event WorkerRegistered(address indexed worker, uint256 stake);
    event StakeIncreased(address indexed worker, uint256 additional);
    event StakeWithdrawn(address indexed worker, uint256 amount);
    event ReputationUpdated(address indexed worker, uint256 newRep);

    constructor() Ownable(msg.sender) {}

    function registerNode(string calldata _metadata) external payable {
        require(msg.value >= 0.1 ether, "Minimum stake 0.1 BNB");
        require(workers[msg.sender].worker == address(0), "Already registered");

        workers[msg.sender] = Worker({
            worker: msg.sender,
            stake: msg.value,
            reputation: 50,
            registrationTime: block.timestamp,
            active: true,
            metadata: _metadata
        });
        workerList.push(msg.sender);
        totalStaked += msg.value;

        emit WorkerRegistered(msg.sender, msg.value);
    }

    function increaseStake() external payable {
        Worker storage w = workers[msg.sender];
        require(w.active, "Not active");
        require(msg.value > 0, "Must send BNB");
        w.stake += msg.value;
        totalStaked += msg.value;
        emit StakeIncreased(msg.sender, msg.value);
    }

    function withdrawStake(uint256 _amount) external {
        Worker storage w = workers[msg.sender];
        require(w.active, "Not active");
        require(w.stake >= _amount, "Insufficient stake");
        require(address(this).balance >= _amount, "Contract balance insufficient");

        w.stake -= _amount;
        totalStaked -= _amount;
        payable(msg.sender).transfer(_amount);
        emit StakeWithdrawn(msg.sender, _amount);
    }

    function getMultiplier(address _worker) public view returns (uint256) {
        Worker storage w = workers[_worker];
        if (!w.active) return 0;
        uint256 daysActive = (block.timestamp - w.registrationTime) / 1 days;
        uint256 stakeFactor = (w.stake / 1 ether) * stakeWeight;
        uint256 timeFactor = daysActive * timeWeight;
        uint256 repFactor = w.reputation * repWeight;
        return baseMultiplier + stakeFactor + timeFactor + repFactor;
    }

    function reputationOf(address _worker) external view returns (uint256) {
        return workers[_worker].reputation;
    }

    // Admin functions
    function updateReputation(address _worker, uint256 _newRep) external onlyOwner {
        workers[_worker].reputation = _newRep;
        emit ReputationUpdated(_worker, _newRep);
    }

    function setWeights(uint256 _base, uint256 _stake, uint256 _time, uint256 _rep) external onlyOwner {
        baseMultiplier = _base;
        stakeWeight = _stake;
        timeWeight = _time;
        repWeight = _rep;
    }

    receive() external payable {}
}
