// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // ⚠️ 危险！先转账，后扣余额 → 重入攻击入口
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= _amount; // 太晚了！
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // 银行需要能够接收存款
    receive() external payable {}
}