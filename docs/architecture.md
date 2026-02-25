# BNB Edge Node OS – Protocol Architecture

## 1. System Overview
BNB Edge Node OS is an orchestration layer for AI Workers. It sits between the physical compute layer (DePIN) and the application layer (AI Agents).

### 1.1 High-Level Flow
1. **Compute Nodes** register via the `WorkerRegistry` smart contract.
2. **Staking** of native BNB activates the node.
3. **OpenClaw Engine** monitors node health and connectivity.
4. **AI Agents** query the registry to route tasks to the highest-reputation nodes.

## 2. Core Components

### 2.1 Smart Contract Layer (opBNB)
- **WorkerRegistry.sol**: Manages identities, staking balances, and reputation scores.
- **Slashing Mechanism**: Automated penalties for node downtime (Phase 2).

### 2.2 Execution Layer (OpenClaw)
A high-performance coordination engine that manages WebSocket connections and task distribution.

### 2.3 Knowledge Layer (Model Hub)
Provides standardized interfaces for LLMs and specialized AI models running on the worker nodes.

## 3. Data Flow
Nodes submit "Proof-of-Computation" hashes periodically to the registry, which updates their on-chain reputation.
