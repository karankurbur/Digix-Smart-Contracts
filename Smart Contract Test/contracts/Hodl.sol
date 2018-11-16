pragma solidity ^0.4.23;

contract Hodl {
    

    uint testingTime = 0;
    bool test;
    uint minimumWaitTime = 15 seconds;
    uint interestPeriod = 30 seconds;
    
    event Withdrawal(
        uint amount    
    );
    
    event timeCheck (
        uint time,
        uint time2 
    );
    
    mapping (address => uint) public storedAmounts;
    mapping (address => uint) public depositTime;
    mapping (address => uint) public rewardClaimTime;
    uint fees;
    
    function Hodl(bool testing) {
        fees = 50000;
        test = testing;
    }
    
    function testTest() {
        require(!test);
    }

    //cant deposit if balance is > 0
    function depositEther(uint amount) public returns (bool) {
        if(storedAmounts[msg.sender] == 0 && depositTime[msg.sender] == 0 && amount > 0) {
            storedAmounts[msg.sender] = amount;
            if(!test) {
                depositTime[msg.sender] = now;
                rewardClaimTime[msg.sender] = now;
            }
            else {
                depositTime[msg.sender] = testingTime;
                rewardClaimTime[msg.sender] = testingTime;
            }
            return true;            
            }
        return false;
    }

    function timeLeft(address user) public returns (uint) {
        uint timeTillFree = minimumWaitTime + depositTime[user];
        uint timeLeft;
        if(!test) {
            timeLeft = timeTillFree - now; 
        }
        else {
            timeLeft = timeTillFree - testingTime; 
        }

        timeCheck(timeLeft,timeTillFree);
        if(timeLeft > timeTillFree) {
            return 0;
        }
        return timeLeft;
    }
    
    function getBalance(address check) returns (uint) {
        return storedAmounts[check];
    }


    function withdrawEther() returns (uint amt, bool success) {
        if(storedAmounts[msg.sender] > 0) {
            uint amountToSend = storedAmounts[msg.sender];
            uint timeTillNoPenalty = timeLeft(msg.sender);
            storedAmounts[msg.sender] = 0; 
            depositTime[msg.sender] = 0;
            rewardClaimTime[msg.sender] = 0;
            if(timeTillNoPenalty == 0) {
                msg.sender.send(amountToSend);
                Withdrawal(amountToSend);
                return (amountToSend,true);
            } else {
                //20% fee if withdrawing early
                uint fee = amountToSend/5;
                uint returnAmount = amountToSend - fee;
                fees+= fee;
                msg.sender.send(returnAmount);
                Withdrawal(returnAmount);
                return (returnAmount,true);
            }

        }
        return (0,false);
    }

    //For ever hour you hold, you gain 5% interest compounded if fees contain enough ether.
    //Contract must contain enough fees to pay built up compounded interest.
    function claimReward() returns (uint reward, uint compoundTimes, bool success){
        //Calculate how many times to compound.
        uint timeSinceLastClaim;
        if(!test) {
            timeSinceLastClaim = now - rewardClaimTime[msg.sender];
        }
        else {
            timeSinceLastClaim  = testingTime - rewardClaimTime[msg.sender];
        }
        
        uint compoundAmount = timeSinceLastClaim / interestPeriod;
        if(compoundAmount <= 0) {
            return (0,0,false);
        }
        //Must reach atleast one hour
        //require(compoundAmount > 0);
        
        //Calculate claim amount
        uint tempBalance = storedAmounts[msg.sender]*105/100;
        for(uint i = 1; i < compoundAmount; i++) {
            tempBalance = tempBalance*105/100;
        }
        uint rewardAmount = tempBalance - storedAmounts[msg.sender];
        
        //Must have enough money in fees
        //require(fees >= rewardAmount);
        if(fees < rewardAmount) {
            return (0,compoundAmount,false);
        }
        
        if(!test) {
            rewardClaimTime[msg.sender] = now;
        }
        else {
            rewardClaimTime[msg.sender] = testingTime;
        }
        
        fees =- rewardAmount;
        storedAmounts[msg.sender] += rewardAmount;
        
        return (rewardAmount,compoundAmount,true);
    }
    
    function getFees() returns (uint) {
        return fees;
    }
    
    function() payable {
        
    }
    
    
}