require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv");
dotenv.config({ path: require("path").resolve(__dirname, ".env") });

console.log("URL:", process.env.SEPOLIA_RPC_URL);

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    }
  },
};