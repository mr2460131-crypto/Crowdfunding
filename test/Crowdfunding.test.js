const {expect} = require("chai");
const {ethers} = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("CrowdFundding ",function(){

    let crowdfundding ;
    let owner;
    let creator;
    let backer1;
    let backer2;
   
    beforeEach(async function(){
      [owner,creator,backer1,backer2] = await ethers.getSigners();
      const CrowdFundding = await ethers.getContractFactory("Crowdfunding");
       crowdfundding = await CrowdFundding.deploy();
    });
  
    it("1.Contract deplpys correctly",async function(){
        expect(await crowdfundding.owner()).to.equal(owner.address);
        expect(await crowdfundding.campaignCount()).to.equal(0);
    });












});