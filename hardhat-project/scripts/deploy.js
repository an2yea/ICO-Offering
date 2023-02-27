const {ethers} = require("hardhat");
require("dotenv").config({path: ".env"});
const {SPRINTERS_CONTRACT_ADDRESS} = require("../contracts");

async function main(){
  const SprinterNFTContract = SPRINTERS_CONTRACT_ADDRESS;

  const SprintersTokenContract = await ethers.getContractFactory("SprintersToken");

  const deployedSprintersContract = await SprintersTokenContract.deploy(SprinterNFTContract);

  await deployedSprintersContract.deployed();

  console.log("Sprinters Token Address", deployedSprintersContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  })