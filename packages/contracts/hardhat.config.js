require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: require("path").resolve(__dirname, "../../.env") });

module.exports = {
    solidity: {
        version: "0.8.25",
        settings: {
            evmVersion: "cancun",
            optimizer: { enabled: true, runs: 200 },
        },
    },
    networks: {
        opbnbTestnet: {
            url: "https://opbnb-testnet-rpc.bnbchain.org",
            chainId: 5611,
            accounts: (process.env.PRIVATE_KEY && process.env.PRIVATE_KEY.length === 66) ? [process.env.PRIVATE_KEY] : [],
        },
    },
    etherscan: {
        apiKey: {
            opbnbTestnet: process.env.NODEREAL_API_KEY,
        },
        customChains: [
            {
                network: "opbnbTestnet",
                chainId: 5611,
                urls: {
                    apiURL: `https://open-platform.nodereal.io/${process.env.NODEREAL_API_KEY}/op-bnb-testnet/contract/`,
                    browserURL: "https://testnet.opbnbscan.com",
                },
            },
        ],
    },
};
