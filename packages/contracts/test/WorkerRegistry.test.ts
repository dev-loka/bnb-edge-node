import { expect } from "chai";
import { ethers } from "hardhat";

describe("WorkerRegistry", function () {
    let registry: any;
    let owner: any;
    let slashing: any;

    beforeEach(async function () {
        const SlashingController = await ethers.getContractFactory("SlashingController");
        slashing = await SlashingController.deploy(ethers.ZeroAddress, ethers.ZeroAddress, ethers.ZeroAddress);

        const WorkerRegistry = await ethers.getContractFactory("WorkerRegistry");
        registry = await WorkerRegistry.deploy(await slashing.getAddress());
        [owner] = await ethers.getSigners();
    });

    it("Should register node", async function () {
        await registry.connect(owner).registerNode("gpu", "QmSpecCID", 1000, { value: 1000 });
        const node = await registry.nodes(owner.address);
        expect(node.stake).to.equal(1000);
    });

    it("Should heartbeat", async function () {
        await registry.connect(owner).registerNode("gpu", "QmSpecCID", 1000, { value: 1000 });
        await registry.connect(owner).heartbeat();
        const node = await registry.nodes(owner.address);
        expect(node.lastHeartbeat).to.be.gt(0);
    });
});

// Add full tests for all contracts
