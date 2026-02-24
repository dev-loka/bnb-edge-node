"use client";

import { useWriteContract } from "wagmi";
import { WorkerRegistryABI, WORKER_REGISTRY_ADDRESS } from "@bnb-edge/sdk/src/abis";
import { ethers } from "ethers";

export default function RegisterNode() {
    const { writeContract } = useWriteContract();

    const handleRegister = (nodeType: string, ipfsCID: string, stake: string) => {
        writeContract({
            address: WORKER_REGISTRY_ADDRESS as `0x${string}`,
            abi: WorkerRegistryABI,
            functionName: "registerNode",
            args: [nodeType, ipfsCID, ethers.parseEther(stake)],
            value: ethers.parseEther(stake),
        });
    };

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6">Register Node</h1>
            <div className="flex gap-4 flex-col max-w-sm">
                <input placeholder="Node Type (gpu/storage)" id="nodeType" className="border px-3 py-2" />
                <input placeholder="IPFS Spec CID" id="ipfsCID" className="border px-3 py-2" />
                <input type="number" placeholder="Stake Amount" id="stake" className="border px-3 py-2" />
                <button onClick={() => handleRegister(
                    (document.getElementById("nodeType") as HTMLInputElement).value,
                    (document.getElementById("ipfsCID") as HTMLInputElement).value,
                    (document.getElementById("stake") as HTMLInputElement).value
                )} className="bg-primary text-primary-foreground px-4 py-2 rounded">Register</button>
            </div>
        </div>
    );
}
