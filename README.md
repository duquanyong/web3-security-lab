# Web3 Security Lab 💼🔐

> **Banking-Grade Security for DeFi** — A hands-on lab demonstrating real-world smart contract vulnerabilities and their fixes, built by a developer with financial industry experience.

This repository showcases practical Web3 security concepts through reproducible experiments — from basic ERC20 tokens to advanced reentrancy attacks and defenses. All code is designed with **user safety** and **financial-grade validation** in mind.

---

## 🎯 Why This Lab?

In traditional banking systems, transactions undergo strict pre-validation (e.g., account format checks, balance verification).  
This lab brings that **same mindset to Web3**, focusing on:

- ✅ **Frontend validation** (e.g., 42-char Ethereum address format check)  
- ✅ **Contract-level security** (e.g., reentrancy protection via OpenZeppelin)  
- ✅ **Real attack simulation & defense** (The DAO-style exploit + fix)

> *"Security isn’t just about writing correct code — it’s about preventing user errors before they happen."*

---

## 🔬 Experiments Included

3. Reentrancy Attack Lab ⚠️→✅

Vulnerable Version	Secure Version
VulnerableBank.sol – allows recursive withdrawal	SecureBank.sol – protected by ReentrancyGuard
Attack succeeds: drains funds in one call	Attack fails: ReentrancyGuard: reentrant call
🔍 Full test coverage with Hardhat:

```bash
npx hardhat test test/reentrancy-test.js   # Shows the exploit
npx hardhat test test/secure-bank-test.js  # Proves the fix
```

🛠️ Tech Stack
Smart Contracts: Solidity ^0.8.20
Framework: Hardhat
Libraries: OpenZeppelin Contracts (security modules)
Frontend: React + Vite + ethers.js
Deployment: Vercel (frontend), Hardhat (local testnet)
▶️ Run the Lab
Clone the repo:
bash

git clone https://github.com/duquanyong/web3-security-lab.git
cd web3-security-lab
Install dependencies (using Yarn for better Windows compatibility):

```bash
yarn install
```

Run tests:

```bash
npx hardhat test
```
