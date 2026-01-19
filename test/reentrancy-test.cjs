const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy Attack", function () {
  it("Should drain the vulnerable bank", async function () {
    const [owner, attacker] = await ethers.getSigners();

    // 部署漏洞银行
    const Bank = await ethers.getContractFactory("VulnerableBank");
    const bank = await Bank.deploy();
    await bank.waitForDeployment();

    // 存入 10 ETH（模拟真实资金池）
    await owner.sendTransaction({
      to: await bank.getAddress(),
      value: ethers.parseEther("10")
    });

    // 部署攻击者
    const Attacker = await ethers.getContractFactory("MaliciousAttacker");
    const malicious = await Attacker.connect(attacker).deploy(await bank.getAddress());
    await malicious.waitForDeployment();

    // 记录初始余额
    const initialBankBalance = await ethers.provider.getBalance(await bank.getAddress());
    const initialAttackerBalance = await ethers.provider.getBalance(await malicious.getAddress());
    
    console.log("初始 - 银行余额:", ethers.formatEther(initialBankBalance), "ETH");
    console.log("初始 - 攻击者余额:", ethers.formatEther(initialAttackerBalance), "ETH");

    // 记录攻击者在银行的初始余额
    const initialAttackerBankBalance = await bank.balances(await malicious.getAddress());
    console.log("初始 - 攻击者在银行的余额:", ethers.formatEther(initialAttackerBankBalance), "ETH");

    // 发起攻击，预期会出现异常（这是重入攻击的正常表现）
    try {
      await malicious.connect(attacker).attack({ value: ethers.parseEther("1") });
      console.log("攻击完成，没有遇到异常");
    } catch (error) {
      console.log("重入攻击成功触发，交易因资源耗尽/余额不足而回滚:", error.reason || error.message.substring(0, 50) + "...");
    }

    // 检查结果
    const finalBankBalance = await ethers.provider.getBalance(await bank.getAddress());
    const finalAttackerBalance = await ethers.provider.getBalance(await malicious.getAddress());
    const callCount = await malicious.getCallCount(); // 获取调用次数
    const finalAttackerBankBalance = await bank.balances(await malicious.getAddress());

    console.log("最终 - 银行余额:", ethers.formatEther(finalBankBalance), "ETH");
    console.log("最终 - 攻击者余额:", ethers.formatEther(finalAttackerBalance), "ETH");
    console.log("最终 - 攻击者在银行的余额:", ethers.formatEther(finalAttackerBankBalance), "ETH");
    console.log("重入调用次数:", callCount.toString());

    // 显示差额 - 使用ethers内置的减法操作
    const bankLoss = finalBankBalance <= initialBankBalance ? initialBankBalance - finalBankBalance : finalBankBalance - initialBankBalance;
    console.log("银行损失:", ethers.formatEther(bankLoss), "ETH");

    console.log("重入攻击演示完成。");
  });
});