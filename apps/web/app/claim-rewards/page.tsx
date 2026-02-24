"use client";

import { useAccount, useWriteContract } from "wagmi";
import { RewardVaultABI, REWARD_VAULT_ADDRESS } from "@bnb-edge/sdk/src/abis";
import axios from "axios";

export default function ClaimRewards() {
    const { address } = useAccount();
    const { writeContract } = useWriteContract();

    const handleClaim = async () => {
        try {
            const res = await axios.get(`/api/rewards/${address}`);
            const { epoch, amount, proof } = res.data;
            writeContract({
                address: REWARD_VAULT_ADDRESS as `0x${string}`,
                abi: RewardVaultABI,
                functionName: "claimReward",
                args: [epoch, amount, proof],
            });
        } catch (err) {
            console.error(err);
        }
    };

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6">Claim Rewards</h1>
            <button onClick={handleClaim} className="bg-primary text-primary-foreground px-4 py-2 rounded">Claim</button>
        </div>
    );
}
