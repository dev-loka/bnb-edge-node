// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./BEdgeToken.sol";
import "./Treasury.sol";

contract EmissionController is Ownable {
    BEdgeToken public token;
    Treasury public treasury;
    uint256 public currentEmissionRate = 1000 * 10**18; // Initial rate
    uint256 public constant HALVING_INTERVAL = 365 days * 4; // Every 4 years
    uint256 public lastHalvingTime;

    event EmissionHalved(uint256 newRate, uint256 timestamp);

    constructor(address _token, address _treasury) Ownable(msg.sender) {
        token = BEdgeToken(_token);
        treasury = Treasury(_treasury);
        lastHalvingTime = block.timestamp;
    }

    function emitToTreasury(uint256 amount) external onlyOwner {
        checkHalving();
        token.mint(address(treasury), amount);
    }

    function checkHalving() public {
        uint256 timeSinceLast = block.timestamp - lastHalvingTime;
        uint256 halvings = timeSinceLast / HALVING_INTERVAL;
        for (uint256 i = 0; i < halvings; i++) {
            currentEmissionRate /= 2;
            lastHalvingTime += HALVING_INTERVAL;
            emit EmissionHalved(currentEmissionRate, block.timestamp);
        }
    }

    function distribute(uint256 team, uint256 liquidity, uint256 rewards) external onlyOwner {
        uint256 total = team + liquidity + rewards;
        treasury.receiveEmission(total);
        treasury.distribute(team, liquidity, rewards);
    }
}
