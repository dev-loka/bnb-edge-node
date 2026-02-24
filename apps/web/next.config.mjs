/** @type {import('next').NextConfig} */
const config = {
    reactStrictMode: true,
    transpilePackages: ['@bnb-edge/sdk'],
    webpack: (config) => {
        config.resolve.alias = {
            ...config.resolve.alias,
            viem: require.resolve('viem'),
        };
        return config;
    },
};

export default config;
