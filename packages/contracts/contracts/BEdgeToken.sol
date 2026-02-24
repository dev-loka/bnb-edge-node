// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract BEdgeToken is ERC20Votes, Ownable, Pausable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18;

    constructor() ERC20("BEdge Token", "BEDGE") ERC20Permit("BEdgeToken") Ownable(msg.sender) {
        _mint(msg.sender, MAX_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) whenNotPaused {
        super._update(from, to, value);
    }
}
