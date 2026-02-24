// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FeeDistributor is Ownable {
    IERC20 public token;
    uint256 public rewardPerTokenStored;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event RewardDistributed(uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function updateReward(address account) internal {
        rewardPerTokenStored = _rewardPerToken();
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
    }

    function _rewardPerToken() internal view returns (uint256) {
        // Logic for accumulator
        return rewardPerTokenStored;
    }

    function distributeReward(uint256 amount) external onlyOwner {
        token.transferFrom(msg.sender, address(this), amount);
        emit RewardDistributed(amount);
    }

    function claim() external {
        updateReward(msg.sender);
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            token.transfer(msg.sender, reward);
        }
    }
}
