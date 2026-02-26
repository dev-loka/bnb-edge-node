import { ethers } from "hardhat";
import * as fs from "fs";

async function main() {
    const [deployer] = await ethers.getSigners();
    const balance = await ethers.provider.getBalance(deployer.address);

    console.log("═══════════════════════════════════════════════");
    console.log("  BNB Edge Node OS — EdgeNodeCore Deployment");
    console.log("═══════════════════════════════════════════════");
    console.log("  Deployer:", deployer.address);
    console.log("  Balance:", ethers.formatEther(balance), "tBNB");
    console.log("  Network:", (await ethers.provider.getNetwork()).name);
    console.log("═══════════════════════════════════════════════\n");

    // Deploy EdgeNodeCore (includes $EDGE ERC-20 + Node Registry)
    console.log("⏳ Deploying EdgeNodeCore...");
    const EdgeNodeCore = await ethers.getContractFactory("EdgeNodeCore");
    const core = await EdgeNodeCore.deploy();
    await core.waitForDeployment();
    const coreAddr = await core.getAddress();
    console.log("✅ EdgeNodeCore:", coreAddr);

    // Verify deployment
    const name = await core.name();
    const symbol = await core.symbol();
    const totalNodes = await core.getTotalNodes();
    console.log(`   Token: ${name} (${symbol})`);
    console.log(`   Active Nodes: ${totalNodes}`);
    console.log(`   Deployer EDGE balance: ${ethers.formatEther(await core.balanceOf(deployer.address))}`);

    // Save addresses for frontend consumption
    const addresses = {
        EdgeNodeCore: coreAddr,
        network: "opBNB Testnet",
        chainId: 5611,
        deployer: deployer.address,
        deployedAt: new Date().toISOString(),
    };

    // Write to project root for easy access
    const outputPath = "../../deployed-addresses.json";
    fs.writeFileSync(outputPath, JSON.stringify(addresses, null, 2));
    console.log(`\n📝 Addresses saved to ${outputPath}`);

    // Also write ABI for frontend
    const artifact = JSON.parse(
        fs.readFileSync("./artifacts/contracts/EdgeNodeCore.sol/EdgeNodeCore.json", "utf8")
    );
    const abiOutput = {
        address: coreAddr,
        abi: artifact.abi,
    };
    fs.writeFileSync("../../edge-node-core-abi.json", JSON.stringify(abiOutput, null, 2));
    console.log("📝 ABI saved to ../../edge-node-core-abi.json");

    console.log("\n═══════════════════════════════════════════════");
    console.log("  🟢 DEPLOYMENT COMPLETE");
    console.log(`  Explorer: https://opbnbscan.com/address/${coreAddr}`);
    console.log("═══════════════════════════════════════════════\n");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
