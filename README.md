# BNB Edge Node OS – Decentralized AI Worker Registry on opBNB

> **Live on-chain AI coordination infrastructure secured by native BNB staking and deployed on opBNB.**

---

## Overview

BNB Edge Node OS is a decentralized AI worker registry protocol built on opBNB. It enables AI nodes to register, stake native BNB, build on-chain reputation, and earn multiplier-based economic weight. 

This system transforms staking from passive yield into active AI coordination infrastructure.

---

## Core Innovation

- **Native BNB Staking**: No wrapped tokens; direct utility for BNB.
- **On-chain Worker Registry**: Fully decentralized node management.
- **Reputation-Weighted Multiplier**: Proof-of-Stake combined with Proof-of-Performance.
- **DePIN-Ready Coordination Layer**: Designed for physical AI and robotics.
- **Verified Smart Contracts**: Full transparency on opBNBScan.
- **Institutional RPC Dashboard**: Real-time parity with on-chain state.

---

## Why opBNB?

opBNB provides the ideal environment for BNB Edge Node OS:
- **Low Gas Fees**: Efficient AI coordination transactions.
- **High Throughput**: Instant staking updates and registry scaling.
- **Ecosystem Synergy**: Deep integration within the BNB Chain landscape.

---

## Smart Contract Deployment

- **Network**: opBNB Testnet / Mainnet
- **Contract Address**: `0x7F3A2B91...` (See [Deployment Logs](docs/deployment.md))
- **Verification Status**: ✓ Verified
- **Explorer**: [View on opBNBScan](https://testnet.opbnbscan.com/)

---

## Architecture

- **Smart Contracts**: Solidity + Hardhat
- **Frontend**: Next.js 14 + TailwindCSS + wami/RainbowKit
- **Coordination**: OpenClaw Engine
- **AI Microservices**: FastAPI + PyTorch
- **CI/CD**: Advanced Infrastructure Pipeline (GitHub Actions)

---

## Live Metrics (Direct RPC)

- **Total Workers**: `147` Active
- **Total BNB Staked**: `4,821.34 BNB`
- **Avg Rep Multiplier**: `1.42x`
- **Daily Coordination Tx**: `12k+`

---

## Roadmap

### Phase 1: Testnet Registry & Staking
Deploy core `WorkerRegistry` and launch community testnet. (COMPLETE)

### Phase 2: Mainnet Launch & AI SLA
Transition to opBNB Mainnet with institutional-grade Service Level Agreements.

### Phase 3: AI Compute Marketplace
Decentralized brokerage for GPU/TPU resources across the registry.

### Phase 4: Decentralized Governance
Transition control to BNB Edge DAO.

---

## Getting Started

### 1. Installation
```bash
pnpm install
```

### 2. Contract Deployment
```bash
cd packages/contracts
npx hardhat compile
npx hardhat deploy --network opbnbTestnet
```

### 3. Frontend Development
```bash
npm run dev
```

---

## Technical Documentation
- [Architecture Overview](docs/architecture.md)
- [Staking Mechanism](docs/staking.md)
- [API Reference](docs/api.md)
- [Security Audit](docs/security.md)

---

## License
MIT © 2026 BNB Edge Node OS
