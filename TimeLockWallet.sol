// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockWallet {
    address public owner;
    uint256 public releaseTime;
    uint256 public lockedAmount;

    constructor(uint256 _releaseTime) {
        owner = msg.sender;
        releaseTime = _releaseTime;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyAfterRelease() {
        require(block.timestamp >= releaseTime, "Funds are locked until the release time");
        _;
    }

    function deposit() external payable onlyOwner {
        lockedAmount += msg.value;
    }

    function withdraw() external onlyOwner onlyAfterRelease {
        uint256 amount = lockedAmount;
        lockedAmount = 0;
        payable(owner).transfer(amount);
    }
}
