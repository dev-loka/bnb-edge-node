# Staking & Economic Model

## 1. Native BNB Staking
Unlike traditional protocols that use synthetic assets, BNB Edge Node OS uses native BNB. This ensures maximum security and zero bridge risk.

### 1.1 Staking Requirements
- **Minimum Stake**: 0.1 BNB
- **Locked Period**: 7 days (standard) / 30 days (premium multiplier)

## 2. Multiplier Dynamics
The system uses a weighted multiplier to determine reward distribution:
`Multiplier = Base (1.0x) + Stake Weight + Time Weight + Reputation Weight`

- **Stake Weight**: 10 basis points per full BNB staked.
- **Time Weight**: 5 basis points per week of continuous uptime.
- **Reputation Weight**: Gains from successful AI task completions.

## 3. Reward Loop
Rewards are distributed every Epoch (24 hours) based on the total share of the multiplier-weighted pool.
