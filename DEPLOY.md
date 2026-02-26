# 🚀 BNB Edge Node OS — Deployment Guide (opBNB Testnet)

## Quick Start (5-Minute Deploy)

### Prerequisites
- [Node.js 18+](https://nodejs.org/)
- MetaMask with tBNB on opBNB Testnet
- Get tBNB from: https://www.bnbchain.org/en/testnet-faucet

### 1. Install Dependencies

```bash
cd packages/contracts
npm install
```

### 2. Setup Environment

```bash
cp ../../.env.example ../../.env
# Edit .env and add:
#   PRIVATE_KEY=0xYOUR_PRIVATE_KEY
#   OPBNB_RPC=https://opbnb-testnet-rpc.bnbchain.org
```

### 3. Compile

```bash
npx hardhat compile
```

### 4. Deploy to opBNB Testnet

```bash
npx hardhat run scripts/deploy-core.ts --network opbnbTestnet
```

Output:
```
═══════════════════════════════════════════════
  BNB Edge Node OS — EdgeNodeCore Deployment
═══════════════════════════════════════════════
  Deployer: 0x7F3A...2B91
  Balance: 0.15 tBNB
  Network: opbnbTestnet
═══════════════════════════════════════════════

⏳ Deploying EdgeNodeCore...
✅ EdgeNodeCore: 0x1234...5678   ← YOUR CONTRACT ADDRESS
   Token: BNB Edge Token (EDGE)
   Active Nodes: 0
   Deployer EDGE balance: 1000.0

📝 Addresses saved to ../../deployed-addresses.json
📝 ABI saved to ../../edge-node-core-abi.json

═══════════════════════════════════════════════
  🟢 DEPLOYMENT COMPLETE
  Explorer: https://opbnbscan.com/address/0x1234...5678
═══════════════════════════════════════════════
```

### 5. Connect the Frontend

Open `index.html` and replace the placeholder contract address:

```javascript
// Line ~3870 — replace the zero address:
const CONTRACT_ADDRESS = '0xYOUR_DEPLOYED_ADDRESS_HERE';
```

The address is also saved in `deployed-addresses.json` at the project root.

### 6. Test

Open `index.html` in your browser with MetaMask installed:

1. **Click the wallet icon** → MetaMask popup → switch to opBNB Testnet
2. **Click "Register Node"** → MetaMask signs `registerNode()` → toast confirms TX
3. **Wait 30 seconds** → pending $EDGE rewards start accruing
4. **Click "Claim $EDGE"** → MetaMask signs `claimRewards()` → $EDGE minted to wallet

---

## Smart Contract Overview

**EdgeNodeCore.sol** — Single consolidated contract:

| Function | Type | Description |
|---|---|---|
| `registerNode(string)` | Write | Register DePIN node with metadata |
| `claimRewards()` | Write | Mint accrued $EDGE tokens |
| `getPendingRewards(address)` | View | Preview pending rewards |
| `getNodeInfo(address)` | View | Get node reputation, uptime, earnings |
| `totalActiveNodes()` | View | Count of active nodes |
| `balanceOf(address)` | View | $EDGE token balance (ERC-20) |
| `updateNodeHealth(address,uint,uint)` | Owner | Simulate AI health updates |

**Reward Rate:** 10 $EDGE per hour of active node time

---

## Network Configuration

| Key | Value |
|---|---|
| Network | opBNB Testnet |
| Chain ID | 5611 |
| RPC | `https://opbnb-testnet-rpc.bnbchain.org` |
| Explorer | `https://opbnbscan.com` |
| Currency | tBNB |
| Avg Gas | ~$0.001 per TX |

---

## Alternative: Deploy via Remix IDE

If you prefer a browser-based deploy:

1. Go to [remix.ethereum.org](https://remix.ethereum.org)
2. Create `EdgeNodeCore.sol`, paste the code
3. Set compiler to `0.8.20`, compile
4. Environment → "Injected Provider - MetaMask"
5. Ensure MetaMask is on opBNB Testnet (Chain ID 5611)
6. Deploy → copy the contract address
7. Paste into `index.html` `CONTRACT_ADDRESS`
