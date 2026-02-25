const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying with account:", deployer.address);

    const WorkerRegistry = await hre.ethers.getContractFactory("WorkerRegistry");
    const registry = await WorkerRegistry.deploy();
    await registry.waitForDeployment();
    const addr = await registry.getAddress();
    console.log("WorkerRegistry deployed to:", addr);
}

main().catch(console.error);
