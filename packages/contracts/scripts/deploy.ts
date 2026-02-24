import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying from:", deployer.address);

    // Deploy BEdgeToken
    const BEdgeToken = await ethers.getContractFactory("BEdgeToken");
    const token = await BEdgeToken.deploy();
    await token.waitForDeployment();
    console.log("BEdgeToken:", await token.getAddress());

    // Deploy WorkerRegistry
    const WorkerRegistry = await ethers.getContractFactory("WorkerRegistry");
    const registry = await WorkerRegistry.deploy(await token.getAddress());
    await registry.waitForDeployment();
    console.log("WorkerRegistry:", await registry.getAddress());

    // Deploy other contracts, setting dependencies
    // ... similar for AgentRegistry, StakingVault, RewardVault, SlashingController, EmissionController, EpochManager, Treasury, FeeDistributor, Governance, TimelockController

    // Save addresses to json
    const addresses = {
        BEdgeToken: await token.getAddress(),
        WorkerRegistry: await registry.getAddress(),
        // ... all others
    };
    const fs = require("fs");
    fs.writeFileSync("deployed.json", JSON.stringify(addresses, null, 2));
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
