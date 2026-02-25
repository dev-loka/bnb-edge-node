require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();

module.exports = {
    solidity: "0.8.20",
    networks: {
        opbnbTestnet: {
            url: "https://opbnb-testnet-rpc.bnbchain.org",
            chainId: 5611,
            accounts: [process.env.PRIVATE_KEY],
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
