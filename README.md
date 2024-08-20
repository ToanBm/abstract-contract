# Deploying Abstract Contract

## Start...
- Open [Github Codespace](https://github.com/codespaces)
- Paste the below command to Deploy Abstract Contract
## Step 1: Setup
### Installing Hardhat
```bash
npm install --save-dev hardhat
```
```bash
npm i -D @matterlabs/hardhat-zksync
```
```bash
npm install dotenv
```
```bash
npx hardhat init
```
After `npx hardhat init` command, it will ask us for some information, enter it as in the image below

![hardhat2](https://github.com/ToanBm/abstract-contract/blob/main/hardhat-project.jpg)

### Hardhat Config
```bash
rm hardhat.config.ts && nano hardhat.config.ts
```
Edit file `hardhat.config.ts` as in the code below. 
(Ctrl + X, Y and Enter will do to save)
```bash
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
```
## Step 2: Writing the Contract
### Installing OpenZeppelin
```bash
npm install @openzeppelin/contracts
```
### Contract Code
```bash
rm contracts/Lock.sol && nano contracts/SampleToken.sol
```
Edit file `SampleToken.sol` as in the code below. 
(Ctrl + X, Y and Enter will do to save)
```bash
// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
 
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
contract SampleToken is ERC20 {
    constructor() ERC20("SampleToken", "SAMPLE") {}
 
    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}
```
### Compiling the Code
```bash
npx hardhat compile --network abstractTestnet
```
## Step 3: Deploying the Contract
### Deploy Script
```bash
mkdir deploy && nano deploy/deploy.ts
```
Edit file `deploy.ts` as in the code below. 
(Ctrl + X, Y and Enter will do to save)
```bash
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
  const artifact = await deployer.loadArtifact("SampleToken");
 
  // Deploy this contract. The returned object will be of a `Contract` type,
  // similar to the ones in `ethers`.
  const tokenContract = await deployer.deploy(artifact);
 
  // Show the contract info.
  console.log(`${artifact.contractName} was deployed to ${await tokenContract.getAddress()}`);
}
```
### Environment Variables
```bash
nano .env
```
* Enter your private key where it says
```bash
PRIVATE_KEY=your-private-key
```
### Deploying
```bash
npx hardhat deploy-zksync --script deploy.ts --network abstractTestnet
```
* You should see the following output in your terminal if everything executed correctly:

`Running deploy script`

`SampleToken was deployed to CONTRACT_ADDRESS`
### Verifying the Contract
```bash
npm i -D @matterlabs/hardhat-zksync-verify
```
```bash
npx hardhat verify --network abstractTestnet CONTRACT_ADDRESS
```
If the command works, you should see the following output in your terminal:

`Your verification ID is: <ID>`

`Contract successfully verified on ZKsync block explorer!`

## Thank you!








