"use client";

import { useWriteContract } from "wagmi";
import { StakingVaultABI, STAKING_VAULT_ADDRESS } from "@bnb-edge/sdk/src/abis";
import { ethers } from "ethers";

export default function Stake() {
    const { writeContract } = useWriteContract();

    const handleStake = (amount: string) => {
        writeContract({
            address: STAKING_VAULT_ADDRESS as `0x${string}`,
            abi: StakingVaultABI,
            functionName: "stake",
            args: [ethers.parseEther(amount)],
        });
    };

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6">Stake BEDGE</h1>
            <div className="flex gap-4">
                <input type="number" placeholder="Amount to stake" id="stakeAmount" className="border px-3 py-2" />
                <button onClick={() => handleStake((document.getElementById("stakeAmount") as HTMLInputElement).value)} className="bg-primary text-primary-foreground px-4 py-2 rounded">Stake</button>
            </div>
        </div>
    );
}
