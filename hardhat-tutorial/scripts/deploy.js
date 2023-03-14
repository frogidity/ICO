const {ethers} = require("hardhat");
require("dotenv").config({path: ".env"});
const { CRYPTO_DEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {

  const cryptoDevsNFTContract = CRYPTO_DEVS_NFT_CONTRACT_ADDRESS;
  const cryptoDevsTokenContract = await ethers.getContractFactory("CryptoDevsToken");
  const deployedContract = await cryptoDevsTokenContract.deploy(cryptoDevsNFTContract);

  await deployedContract.deployed();

  console.log("Crypto Devs Token Contract Address:", deployedContract.address);

}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
}

runMain();