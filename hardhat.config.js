require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/z05hUGmTB1TT4Fx6iqlfU9-w8-eXsder",
        blockNumber: 12088078,
      },
      chainId: 1337,
    },
  },
};
