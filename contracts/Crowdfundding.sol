// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
 
  contract Crowdfunding{
          address public owner;
           struct Campaigns{
            address creator;
            string title;
            string description;
            uint256 deadline;
            uint256 amountRaised;
            uint256 goalAmount;
            bool claimed;
        mapping(address => uint256) contributors;
           }
      uint256  public campaignCount;
     mapping(uint256 => Campaigns) public campaigns;
      /// set notification//
    event CampaignCreated(uint256 campaingnID,address creator,uint256 amount,uint256 deadline);
    event ContributionReceived( uint256 campaignID,address contributor,uint256  amount);
    event FundsClaimed(uint256 campaignId, address creator, uint256 amount);
    event RefundIssued(uint256 campaignId, address backer, uint256 amount);
     /// let's declear the owner//
      constructor(){
         owner = msg.sender;
      }
       modifier onlyCreator(uint256 ID){
               require(msg.sender == campaigns[ID].creator, "Only campaign creator can call this");
               _; 
      }
      // let's start writting function//
       function createCampaign(
       string memory tittle,
       string memory description,
       uint256 goalAmount,
       uint256 durationInDays )
       public{
           require(goalAmount >0,"Goal must be greater than 0");
        require(durationInDays >=1 && durationInDays<=60,"Campaign will be finished by 60 days");
              uint256 deadline = block.timestamp + (durationInDays * 1 days);  
                campaigns[campaignCount].creator = msg.sender;
                campaigns[campaignCount].title = tittle;
                campaigns[campaignCount].description = description;
                campaigns[campaignCount].goalAmount = goalAmount;
                campaigns[campaignCount].amountRaised = 0;
                campaigns[campaignCount].claimed = false;
                campaigns[campaignCount].deadline = deadline;
                campaignCount++;
     emit CampaignCreated(campaignCount - 1, msg.sender, goalAmount, deadline);
       }

            

     function contribute(uint campaignID) public payable{
          require(block.timestamp<campaigns[campaignID].deadline,"Time Over");
          require(msg.value >0,"Must send ETH");
campaigns[campaignID].amountRaised += msg.value;
campaigns[campaignID].contributors[msg.sender] += msg.value;
emit ContributionReceived(campaignID, msg.sender, msg.value);

     }  
function claimFunds( uint256 campaignID) public onlyCreator(campaignID){
          require(block.timestamp> campaigns[campaignID].deadline,"Wait till to the deadline");
          require(campaigns[campaignID].amountRaised >= campaigns[campaignID].goalAmount,"Goal not achived");
          require(campaigns[campaignID].claimed==false,"already taken");
         campaigns[campaignID].claimed =true;
      
        (bool success, ) = payable(campaigns[campaignID].creator).call{value: campaigns[campaignID].amountRaised}("");
        require(success,"Transfer Failed");
        emit FundsClaimed(campaignID, msg.sender, campaigns[campaignID].amountRaised);
       }
      function refund(uint256 campaignID) public{
         require(block.timestamp>campaigns[campaignID].deadline,"campaign is still active");
         require(campaigns[campaignID].amountRaised <campaigns[campaignID].goalAmount," you need for till deadline");
         uint256 amount = campaigns[campaignID].contributors[msg.sender];
          require(amount >0,"No contribuation");

          campaigns[campaignID].contributors[msg.sender] = 0;
      
         (bool success,  ) = payable(msg.sender).call{value:amount}("");
      require(success,"transfer failed");
          emit RefundIssued(campaignID, msg.sender, amount);
      }

function getCampaign(uint256 campaignID) public view returns(
   address creator,
   string memory title,
   string memory description,
   uint256 goalAmount,
   uint256 deadline,
   uint256 amountRaised,
   bool claimed){
     Campaigns storage c = campaigns[campaignID];
    return(c.creator,c.title,c.description,c.goalAmount,c.deadline,c.amountRaised,c.claimed);
   }


  }