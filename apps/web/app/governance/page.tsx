"use client";

import { useReadContract } from "wagmi";
import { GovernanceABI, GOVERNANCE_ADDRESS } from "@bnb-edge/sdk/src/abis";

export default function Governance() {
    const { data: proposals } = useReadContract({
        address: GOVERNANCE_ADDRESS as `0x${string}`,
        abi: GovernanceABI,
        functionName: "getProposals", // Assume function exists
    });

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6">Governance</h1>
            {/* List proposals */}
            <button className="bg-primary text-primary-foreground px-4 py-2 rounded">Create Proposal</button>
        </div>
    );
}
