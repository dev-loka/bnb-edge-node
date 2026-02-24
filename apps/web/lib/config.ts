import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { opbnbTestnet, opbnb } from "@bnb-edge/sdk/src/chains";
import { http } from "viem";

export const config = getDefaultConfig({
    appName: "BNB Edge Node OS",
    projectId: process.env.NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID || "temp_id",
    chains: [opbnbTestnet, opbnb],
    transports: {
        [opbnbTestnet.id]: http(),
        [opbnb.id]: http(),
    },
});
