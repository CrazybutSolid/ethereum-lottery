pragma solidity ^0.4.11;

// Contract that:
//      Lets anyone bet with 1 ether
//      When it reaches 5 bets, it chooses a gambler at random and sends the 5 ethers received


library SafeMath {
  function mul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title PullPayment
 * @dev Base contract supporting async send for pull payments. Inherit from this
 * contract and use asyncSend instead of send.
 */
contract PullPayment {
  using SafeMath for uint256;

  mapping(address => uint256) public payments;
  uint256 public totalPayments;

  /**
  * @dev Called by the payer to store the sent amount as credit to be pulled.
  * @param dest The destination address of the funds.
  * @param amount The amount to transfer.
  */
  function asyncSend(address dest, uint256 amount) internal {
    payments[dest] = payments[dest].add(amount);
    totalPayments = totalPayments.add(amount);
  }

  /**
  * @dev withdraw accumulated balance, called by payee.
  */
  function withdrawPayments() {
    address payee = msg.sender;
    uint256 payment = payments[payee];

    if (payment == 0) {
      throw;
    }

    if (this.balance < payment) {
      throw;
    }

    totalPayments = totalPayments.sub(payment);
    payments[payee] = 0;

    if (!payee.send(payment)) {
      throw;
    }
  }
}

contract Lottery is PullPayment {


    
        // A mapping to store ethereum addresses
            mapping(uint => address) public gamblers;
            
            
            uint8 public player_count; //keep track of how many people.
            uint public ante; //keep track of how many people.
            uint8 public required_number_players; //keep track of how many people.
            uint public random; //random number
            uint public winner_part;
            address public winner; //the last winner of the lottery
            address owner;


            
            function Lottery(){
                owner = msg.sender;
                player_count = 0;
                ante = 0.2 ether;
                required_number_players = 5;
                winner_part = 0.8 ether;
            }

            function changeParameters(uint newAnte, uint8 newNumberOfPlayers, uint newWinnerPart) {
        // Only the creator can alter the name --
        // the comparison is possible since contracts
        // are implicitly convertible to addresses.
        if (msg.sender == owner) {
             if (newAnte != 0) {
                ante = newAnte;
             }
             if (newNumberOfPlayers != 0) {
                required_number_players = newNumberOfPlayers;
             }
             if (newWinnerPart != 0) {
                winner_part = newWinnerPart;
            }
            }
    }
// announce the winner with an event
            event Announce_winner(
        address indexed _from,
        address indexed _to,
        uint _value
    );
// conditional to make sure participants send the right ante. haven't been able to make this work yet
            //modifier only_right_ante(uint x) {
              //  if (balances[msg.value] == x) _;
            //}
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
        require(msg.value == ante);
        
        player_count +=1;
        
        gamblers[player_count] = msg.sender;
    
        if (player_count == required_number_players) {
            // pick a random number between 1 and 5
            random = uint(block.blockhash(block.number-1))%5 + 1;
            asyncSend(gamblers[random],winner_part);
            // previous method to directly transfer winnings
            //gamblers[random].transfer(0.8 ether);
            Announce_winner(this,gamblers[random],winner_part);
            // save the last winner
            winner = gamblers[random];
            // sends 0.2 ethers to GiveDirectly in production
            // 0x512c3FCccdEFDa5D58E188b1AF39893e5D147aA3.transfer(0.2 ether);
            // Fake Give Directly address (Ropsten)
            0xd60406B842Ba7bCA8E83aF189e2A1bc96b24072B.transfer(0.2 ether);
            player_count = 0;
            gamblers[1] = 0;
            gamblers[2] = 0;
            gamblers[3] = 0;
            gamblers[4] = 0;
            gamblers[5] = 0;

        }
    }
}