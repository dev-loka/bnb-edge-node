import { defineChain } from "viem";

export const opbnbTestnet = defineChain({
    id: 5611,
    name: 'opBNB Testnet',
    network: 'opbnb-testnet',
    nativeCurrency: { name: 'tBNB', symbol: 'tBNB', decimals: 18 },
    rpcUrls: {
        default: { http: ['https://opbnb-testnet-rpc.bnbchain.org'] },
        public: { http: ['https://opbnb-testnet-rpc.bnbchain.org'] },
    },
    blockExplorers: {
        default: { name: 'opBNBScan', url: 'https://testnet.opbnbscan.com' },
    },
});

export const opbnb = defineChain({
    id: 204,
    name: 'opBNB',
    network: 'opbnb-mainnet',
    nativeCurrency: { name: 'BNB', symbol: 'BNB', decimals: 18 },
    rpcUrls: {
        default: { http: ['https://opbnb-mainnet-rpc.bnbchain.org'] },
        public: { http: ['https://opbnb-mainnet-rpc.bnbchain.org'] },
    },
    blockExplorers: {
        default: { name: 'opBNBScan', url: 'https://mainnet.opbnbscan.com' },
    },
});
