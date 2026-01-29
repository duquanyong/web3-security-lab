// scripts/deploy.js
import hre from "hardhat";

async function main() {
  // 获取合约工厂（确保合约名和文件名一致）
  const SecureBank = await hre.ethers.getContractFactory("SecureBank");
  
  // 部署合约
  const secureBank = await SecureBank.deploy();
  
  // 等待部署确认
  await secureBank.waitForDeployment();
  
  // 打印合约地址
  console.log("✅ SecureBank deployed to:", await secureBank.getAddress());
}

// 错误处理
main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});