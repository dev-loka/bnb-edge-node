// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "./BEdgeToken.sol";

contract Governance is Governor, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction {
    constructor(IVotes _token)
        Governor("BEdgeGovernance")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4) // 4% quorum
    {}

    function votingDelay() public pure override returns (uint256) {
        return 1; // 1 block
    }

    function votingPeriod() public pure override returns (uint256) {
        return 50400; // ~1 week (7*7200 blocks)
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 100_000 * 10**18; // 100k tokens to propose
    }

    function quorum(uint256 blockNumber) public view override returns (uint256) {
        return super.quorum(blockNumber);
    }
}
