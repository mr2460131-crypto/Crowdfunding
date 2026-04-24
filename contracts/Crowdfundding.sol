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
        require(goalAmount >0,"Goal amount be greater than sorry");
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

  }