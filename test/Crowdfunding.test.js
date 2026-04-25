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
    it("04. Users can contribute ETH to a campaign", async function() {
        await crowdfundding.connect(creator).createCampaign("test campaign","test description",ethers.parseEther("10"),30);
        await crowdfundding.connect(backer1).contribute(0,{value: ethers.parseEther("1")});
        const campaign = await crowdfundding.getCampaign(0);
        expect(campaign.amountRaised).to.equal(ethers.parseEther("1"));
    });
     
   it("05 Contribution fails after deadline",async function(){
       await crowdfundding.connect(creator).createCampaign("test campaign ","test description",ethers.parseEther("10"),30);
       await time.increase(31 * 24 * 60 * 60);
       await expect(crowdfundding.connect(backer1).contribute(0, {value: ethers.parseEther("1")})).to.be.revertedWith("Time Over");
     });
   it("06.Contribution will be faill if contribution amout 0 ETH",async function () {
         await crowdfundding.connect(creator).createCampaign("test campaing ","test description",ethers.parseEther("10"),30);
         await expect(crowdfundding.connect(backer1).contribute(0, {value: ethers.parseEther("0")})).to.be.revertedWith("Must send ETH");   
    
     });
   it("07.campaign creator can withdraw found",async function(){
      await crowdfundding.connect(creator).createCampaign("test campaign","test description",ethers.parseEther("10"),30);
      await crowdfundding.connect(backer1).contribute(0,{value: ethers.parseEther("10")});
      await time .increase(31*24*60*60);
      await  crowdfundding.connect(creator).claimFunds(0);
      const campaign = await crowdfundding.getCampaign(0);
      expect (campaign.claimed).to.equal(true);
      });
    













});