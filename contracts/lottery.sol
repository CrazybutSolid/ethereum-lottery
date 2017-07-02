pragma solidity ^0.4.11;

// Contract that:
//      Lets anyone bet with 1 ether
//      When it reaches 5 bets, it chooses a gambler at random and sends the 5 ethers received
contract Lottery {
    
        // A mapping to store ethereum addresses
            mapping(uint => address) public gamblers;
            
            
            uint public my_length; //*to keep track of the length.
            uint public random; //random number
            address public winner; //the last winner of the lottery
            
            function Lottery(){
                my_length = 0;
            }
        // function when someone sends an ether
        // stores the address, and if there are 5 participants, 
        // chooses a winner and gives the money
        
        function () payable {
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.

        // If the bet is not 0.2 ether, send the
        // money back.
        require(msg.value == 0.2 ether);
        
        my_length +=1;
        
        gamblers[my_length] = msg.sender;
    
        if (my_length == 5) {
            // pick a random number between 1 and 5
            random = uint(block.blockhash(block.number-1))%5 + 1;
            gamblers[random].transfer(0.5 ether);
            // save the last winner
            winner = gamblers[random];
            // sends 0.2 ethers to GiveDirectly in production
            // 0x512c3FCccdEFDa5D58E188b1AF39893e5D147aA3.transfer(0.2 ether);
            // Fake Give Directly address (Ropsten)
            0xd60406B842Ba7bCA8E83aF189e2A1bc96b24072B.transfer(0.2 ether);
            my_length = 0;
            gamblers[1] = 0;
            gamblers[2] = 0;
            gamblers[3] = 0;
            gamblers[4] = 0;
            gamblers[5] = 0;

        }
    }
}