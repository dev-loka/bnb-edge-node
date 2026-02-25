# BNB Edge Node OS

Welcome to the BNB Edge Node OS DePIN protocol. This is a full production monorepo containing:
- Turborepo
- Next.js Web Frontend & Serverless APIs (Drizzle ORM)
- FastAPI AI Service
- Hardhat Contracts

## Getting Started
1. Run `pnpm install` in the root.
2. For contracts: `cd packages/contracts` → `npx hardhat deploy`
3. For frontend + API: `cd apps/web` → `pnpm dev`
4. For AI: `cd apps/ai-service` → `uvicorn main:app --reload`
5. Docker: `docker compose up -d`
