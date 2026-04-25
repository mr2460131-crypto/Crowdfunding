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
    it("02.VALID INPUT DIYE CAMAPAIGN CREAT KORA",async function () {
        /// amara akata creator Wallet diye notun campaign toiri korbo//
        await crowdfundding.connect(creator).createCampaign("test campaign","test description",ethers.parseEther("10"),30);
        expect(await crowdfundding.campaignCount()).to.equal(1);
    });
    it("03. amar campaign start korar try korbo goal amount 0 diya",async function (){
          await expect(crowdfundding.connect(creator).createCampaign("test campaign","test description",0,30)).to.be.revertedWith("Goal must be greater than 0");
       });    
        
    












});