// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract RewardVault is Ownable {
    IERC20 public rewardToken;
    mapping(uint256 => bytes32) public epochRoots;
    mapping(uint256 => string) public epochIPFSCIDs;
    mapping(uint256 => uint256) public epochTotals;
    mapping(address => uint256) public lastClaimedEpoch;

    event EpochRootSubmitted(uint256 indexed epoch, bytes32 root, uint256 total, string ipfsCID);
    event RewardClaimed(address indexed user, uint256 indexed epoch, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        rewardToken = IERC20(_token);
    }

    function submitEpochRoot(uint256 epoch, bytes32 root, uint256 totalAmount, string memory ipfsCID) external onlyOwner {
        require(epochRoots[epoch] == 0, "Epoch already submitted");
        epochRoots[epoch] = root;
        epochTotals[epoch] = totalAmount;
        epochIPFSCIDs[epoch] = ipfsCID;
        emit EpochRootSubmitted(epoch, root, totalAmount, ipfsCID);
    }

    function claimReward(uint256 epoch, uint256 amount, bytes32[] calldata proof) external {
        require(epoch > lastClaimedEpoch[msg.sender], "Already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        require(MerkleProof.verify(proof, epochRoots[epoch], leaf), "Invalid proof");
        rewardToken.transfer(msg.sender, amount);
        lastClaimedEpoch[msg.sender] = epoch;
        emit RewardClaimed(msg.sender, epoch, amount);
    }

    function batchClaim(uint256[] calldata epochs, uint256[] calldata amounts, bytes32[][] calldata proofs) external {
        require(epochs.length == amounts.length && epochs.length == proofs.length, "Mismatch");
        for (uint256 i = 0; i < epochs.length; i++) {
            // Call single claim logic
            bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amounts[i]));
            require(MerkleProof.verify(proofs[i], epochRoots[epochs[i]], leaf), "Invalid proof");
            rewardToken.transfer(msg.sender, amounts[i]);
            lastClaimedEpoch[msg.sender] = epochs[i];
            emit RewardClaimed(msg.sender, epochs[i], amounts[i]);
        }
    }
}
