// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TimelockController.sol";

contract Treasury is Ownable {
    IERC20 public token;
    TimelockController public timelock;

    event FundsReceived(uint256 amount, address from);
    event FundsDistributed(uint256 team, uint256 liquidity, uint256 rewards);

    constructor(address _token, address _timelock) Ownable(msg.sender) {
        token = IERC20(_token);
        timelock = TimelockController(payable(_timelock));
    }

    function receiveEmission(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        emit FundsReceived(amount, msg.sender);
    }

    function distribute(uint256 team, uint256 liquidity, uint256 rewards) external onlyOwner {
        // Logic to distribute to team multisig, liquidity pool, rewards vault
        // Use timelock for large withdrawals
        emit FundsDistributed(team, liquidity, rewards);
    }

    function withdraw(address to, uint256 amount) external {
        require(msg.sender == address(timelock), "Only timelock");
        token.transfer(to, amount);
    }
}
