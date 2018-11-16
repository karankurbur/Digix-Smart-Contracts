pragma solidity ^0.4.23;

import "truffle/Assert.sol";
//import "truffle/DeployedAddresses.sol";
import "../contracts/Hodl.sol";

contract TestHodl{
    
    //withdrawal with fee -> check amount returned and fees go up
    //withdrawal without fee -> check amount returned and fees stay same
    //wait more than return time -> deposit goes up, fee goes down
    
   // @exception - wait less than return time -> no reward (add event for reward amount)
   // @exception - try to claim reward when not enough fees 
    //@exception - try to withdraw with no stored ether
    //@exception - try to deposit ether when already storing some
    function TestWithdrawWithFee() {
        //Hodl hodl = Hodl(DeployedAddresses.Hodl());
        Hodl hodl = new Hodl(true);
        bool correct = hodl.depositEther(0);
        Assert.equal(true, correct, "Owner should have been set");
    }
}