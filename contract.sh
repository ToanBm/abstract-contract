#!/bin/bash
# Logo
echo -e "\033[0;34m"
echo "Logo is comming soon..."
echo -e "\e[0m"

# Step 1: Install the required dependencies
echo "Install Hardhat..."
npm install --save-dev hardhat
npm i -D @matterlabs/hardhat-zksync
npm install dotenv
npm install @openzeppelin/contracts
npm i -D @matterlabs/hardhat-zksync-verify

# Step 2: Create a new project "Create a Typescript Project"
echo "Creating a Typescript Project..."
yes "1" | npx hardhat init

# Step 3: Modify the Hardhat configuration 
echo "Creating new hardhat.config file..."
rm hardhat.config.js

cat <<'EOL' > hardhat.config.js
import { HardhatUserConfig } from "hardhat/config";
 
import "@matterlabs/hardhat-zksync";
 
const config: HardhatUserConfig = {
  zksolc: {
    version: "latest",
    settings: {},
  },
  defaultNetwork: "abstractTestnet",
  networks: {
    abstractTestnet: {
      url: "https://api.testnet.abs.xyz",
      ethNetwork: "sepolia",
      zksync: true,
      verifyURL: 'https://api-explorer-verify.testnet.abs.xyz/contract_verification',
    },
  },
  solidity: {
    version: "0.8.24",
  },
};
 
export default config;
EOL

# Step 4: Write a smart contract
echo "Create ERC20 contract..."
rm contracts/Lock.sol
cat <<'EOL' > contracts/HelloAbstract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract HelloAbstract {
    function sayHello() public pure virtual returns (string memory) {
        return "Hello, World!";
    }
}
EOL

# Step 5: Compile the smart contract
echo "Compile your contracts..."
npx hardhat clean
npx hardhat compile --network abstractTestnet

# Step 6: Deploy the smart contract
echo "Setting Private Key env..."

read -p "Enter your EVM wallet private key (without 0x): " PRIVATE_KEY
cat <<EOF > .env
PRIVATE_KEY=$PRIVATE_KEY
EOF

echo "Creating deploy script..."
mkdir deploy

cat <<'EOL' > deploy/deploy.ts
import { utils, Wallet } from "zksync-ethers";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync";
// Load environment variables (if using dotenv)
require('dotenv').config();

// Initialize the wallet using the private key from the environment variable
const privateKey = process.env.PRIVATE_KEY; // Ensure this is set in your .env file
const wallet = new Wallet(privateKey);

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running deploy script`);
 
  // Create deployer object and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet);
  // Load contract
  const artifact = await deployer.loadArtifact("HelloAbstract");
 
  // Deploy this contract. The returned object will be of a `Contract` type,
  // similar to the ones in `ethers`.
  const tokenContract = await deployer.deploy(artifact);
 
  // Show the contract info.
  console.log(`${artifact.contractName} was deployed to ${await tokenContract.getAddress()}`);
}
EOL

# "Waiting before deploying..."
sleep 5

# Step 8: Deploy the contract to the Hemi network
echo "Deploy your contracts..."
npx hardhat deploy-zksync --script deploy.ts

echo "Follow next step to Verifying the Contract"

echo "Thank you!"
