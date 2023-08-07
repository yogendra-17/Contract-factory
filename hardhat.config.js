require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  etherscan: {
    apiKey: "8E1WJJ78616ST8MMSMVCU4QXWI6T3J74BT",
  },
  networks: {
    mumbai: {
      url: "https://matic-mumbai.chainstacklabs.com",
    },
  },
};