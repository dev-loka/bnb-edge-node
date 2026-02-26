# 🔒 Secure Deployment Runbook — BNB Edge Node OS

## Pre-Flight Checklist

Run these commands **locally on your machine** from the repo root:

```bash
cd /media/hp-ml10/Projects/bnb-edge-node
```

### ✅ Step 1: Verify .gitignore is protecting secrets

```bash
# Should show .env and .env.* patterns
grep "\.env" .gitignore

# Should return "No secret files tracked"
git ls-files | grep -iE '\.env$|\.pem$|\.key$|private' && echo "⚠️  SECRETS IN GIT!" || echo "✅ Clean"
```

### ✅ Step 2: Create .env (edit PRIVATE_KEY locally — NEVER paste it anywhere public)

```bash
cat > .env <<'EOF'
PRIVATE_KEY=0x_REPLACE_WITH_YOUR_KEY_LOCALLY
OPBNB_RPC=https://opbnb-testnet-rpc.bnbchain.org
EOF

# Lock permissions (owner-only read)
chmod 600 .env

# Verify it's ignored
git status .env
# Should say: "nothing to commit" or ".env" not listed
```

> 🛡️ **Use a throwaway testnet wallet.** Export its private key from MetaMask →
> Account Details → Export Private Key. This wallet only needs ~0.01 tBNB for gas.

### ✅ Step 3: Verify .env is NOT staged

```bash
git status
# .env should NOT appear in staged or untracked files
# If it does: rm .env from staging with: git rm --cached .env
```

### ✅ Step 4: Get testnet tBNB

If your deployer wallet has no tBNB:
- Official faucet: https://www.bnbchain.org/en/testnet-faucet
- Discord faucet: BNB Chain Discord → #testnet-faucet channel

You need ~0.01 tBNB (opBNB gas is extremely cheap).

---

## Deployment

### ✅ Step 5: Deploy EdgeNodeCore to opBNB Testnet

```bash
cd packages/contracts
npx hardhat run scripts/deploy-core.js --network opbnbTestnet
```

**Expected output:**
```
═══════════════════════════════════════════════
  BNB Edge Node OS — EdgeNodeCore Deployment
═══════════════════════════════════════════════
  Deployer: 0xYourAddress
  Balance: 0.XX tBNB
═══════════════════════════════════════════════

⏳ Deploying EdgeNodeCore...
✅ EdgeNodeCore: 0xDEPLOYED_ADDRESS    ← COPY THIS

📝 Addresses saved to ../../deployed-addresses.json
📝 ABI saved to ../../edge-node-core-abi.json

═══════════════════════════════════════════════
  🟢 DEPLOYMENT COMPLETE
  Explorer: https://testnet.opbnbscan.com/address/0xDEPLOYED_ADDRESS
═══════════════════════════════════════════════
```

### ✅ Step 6: Wire the frontend to the deployed contract

```bash
cd ../..

# Replace the zero-address placeholder with your deployed address
# Replace YOUR_DEPLOYED_ADDRESS below with the actual address from Step 5
sed -i "s|const CONTRACT_ADDRESS = '0x0000000000000000000000000000000000000000'|const CONTRACT_ADDRESS = 'YOUR_DEPLOYED_ADDRESS'|" index.html

# Verify it was replaced
grep "CONTRACT_ADDRESS = " index.html | head -1
```

### ✅ Step 7: Verify in browser

1. Open `index.html` in Chrome/Firefox (with MetaMask installed)
2. Click the **wallet icon** (top-right) → MetaMask popup → connect
3. Should auto-switch to opBNB Testnet (Chain ID 5611)
4. Click **"Register Node"** → MetaMask signs tx → toast shows tx hash
5. Wait 30s → click **"Claim $EDGE"** → MetaMask signs tx → $EDGE minted
6. Open terminal tab → type `status` → shows real wallet info

---

## Post-Deployment Verification

```bash
# Check contract on explorer
echo "https://testnet.opbnbscan.com/address/$(cat deployed-addresses.json | grep EdgeNodeCore | cut -d'"' -f4)"

# Verify deployed-addresses.json has the right data
cat deployed-addresses.json
```

---

## Demo Recording Script (3 minutes)

For the hackathon submission video:

1. **[0:00-0:30]** Show the dashboard — explain DePIN Farm + AI Agents
2. **[0:30-1:00]** Click wallet → MetaMask popup → connect → show address in header
3. **[1:00-1:30]** Click "Register Node" → show MetaMask TX → show toast confirmation
4. **[1:30-2:00]** Wait, then click "Claim $EDGE" → show MetaMask TX → toast shows minted amount
5. **[2:00-2:30]** Open terminal → type `status` → shows live wallet + contract info
6. **[2:30-3:00]** Open opBNBScan → show the contract + transactions → verified on-chain

---

## 🛡️ Security Reminders

- ❌ **NEVER** commit `.env` files
- ❌ **NEVER** paste private keys in chat, issues, PRs, or CI logs
- ❌ **NEVER** use a mainnet wallet with real funds for testnet deployments
- ✅ Use a **throwaway wallet** with only testnet tokens
- ✅ Verify `git status` before every commit
- ✅ If a key is ever exposed: **move funds immediately** and rotate the key
