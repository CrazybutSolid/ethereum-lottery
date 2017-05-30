pragma solidity ^0.4.11;

// Contract that:
//      Lets anyone bet with 1 ether
//      When it reaches 5 bets, it chooses a gambler at random and sends the 5 ethers received
contract Lottery {
    
        // A mapping to store ethereum addresses
            mapping(uint => address) public gamblers;
            
            
            uint public my_length; //*to keep track of the length.
            uint public random; //random number
            
            function Lottery(){
                my_length = 0;
            }
        // function when someone sends an ether
        // stores the address, and if there are 5 participants, 
        // chooses a winner and gives the money
        
        function bet() payable {
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.

        // If the bet is not 1 ether, send the
        // money back.
        require(msg.value == 1 ether);
        
        my_length +=1;
        
        gamblers[my_length] = msg.sender;
    
        if (my_length == 5) {
            // pick a random number between 1 and 5
            random = uint(block.blockhash(block.number-1))%5 + 1;
            gamblers[random].transfer(5 ether);
            // when splitting the gains for future usage 0x8ad2b6F71ac9864cAa96EF0D9F7a554Dc3619eF8.transfer(2.5 ether);
            my_length = 0;

        }
    }
}