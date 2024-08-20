## Deploying Abstract Contract

## Step 1: Installation of Required Tools
```bash
npm install --save-dev hardhat
```
```bash
npm i -D @matterlabs/hardhat-zksync
```
```bash
npm install @openzeppelin/contracts
```
```bash
npm install dotenv
```
## Step 2: Initializing the Project
```bash
npx hardhat init
```
## Step 2: Hardhat Config
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
npm install @openzeppelin/contracts
```

## Step 2: Initializing the Project
```bash
npx hardhat init
```
## Step 2: Initializing the Project

