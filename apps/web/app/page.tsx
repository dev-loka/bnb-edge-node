"use client";

import { useAccount, useReadContract } from "wagmi";
import { WorkerRegistryABI, WORKER_REGISTRY_ADDRESS } from "@bnb-edge/sdk/src/abis";
import { ethers } from "ethers";

export default function Dashboard() {
    const { address } = useAccount();

    const { data: totalStaked } = useReadContract({
        address: WORKER_REGISTRY_ADDRESS as `0x${string}`,
        abi: WorkerRegistryABI,
        functionName: "totalStaked",
    });

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6">Dashboard</h1>
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                <div className="border p-4 rounded-lg bg-card">
                    <h3 className="font-semibold">Total Staked</h3>
                    <p className="text-2xl font-bold">{totalStaked ? ethers.formatEther(totalStaked as bigint) : '0'} BEDGE</p>
                </div>
            </div>
        </div>
    );
}
