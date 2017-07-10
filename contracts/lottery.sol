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



    mapping(uint => address) public gamblers;// A mapping to store ethereum addresses of the gamblers
    mapping(uint => address) public winners;// A mapping to store ethereum addresses of the winners
    uint8 winner_count; //keep track of how many people are signed up.
    uint8 public player_count; //keep track of how many people are signed up.
    uint public ante; //how big is the bet per person (in ether)
    uint8 public required_number_players; //how many sign ups trigger the lottery
    uint random; //random number
    uint public winner_percentage; // how much does the winner get (in percentage)
    address public winner; //the last winner of the lottery
    address owner; // owner of the contract
    uint80 constant None = uint80(0); //null constant
    uint total_payout; // the payout 
    uint givedirectly_payout; // the payout 
    uint winner_payout; // the payout 


    //constructor
    function Lottery(){
        owner = msg.sender;
        player_count = 0;
        winner_count = 0;
        ante = 0.2 ether;
        required_number_players = 5;
        winner_percentage = 80;
    }

    //adjust the ante, player number and percentage for the winner
    function changeParameters(uint newAnte, uint8 newNumberOfPlayers, uint newWinnerPercentage) {
        // Only the creator can alter this
        if (msg.sender == owner) {
           if (newAnte != None) {
            ante = newAnte;
        }
        if (newNumberOfPlayers != None) {
            required_number_players = newNumberOfPlayers;
        }
        if (newWinnerPercentage != None) {
            winner_percentage = newWinnerPercentage;
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
  
  // function when someone gambles a.k.a sends ether to the contract
  function () payable {
    // No arguments are necessary, all
    // information is already part of
    // the transaction. The keyword payable
    // is required for the function to
    // be able to receive Ether.

    // If the bet is not equal to the ante, send the
    // money back.
    if (msg.value < ante) {
        msg.sender.transfer(msg.value - 0.01 ether);
        } else {
            //require(msg.value == ante);

            player_count +=1;

            gamblers[player_count] = msg.sender;

            // when we have enough participants
            if (player_count == required_number_players) {
                // pick a random number between 1 and 5
                random = uint(block.blockhash(block.number-1))%5 + 1;
                // save the last winner
                winner = gamblers[random];
                // make payment available for the winner to withdraw
                total_payout = ante*required_number_players;
                winner_payout = total_payout*winner_percentage/100;
                givedirectly_payout = total_payout - winner_payout;

                // more secure way to move funds: make the winners withdraw them. Will implement later.
                //asyncSend(gamblers[random],winner_payout);

                // previous method to directly transfer winnings
                gamblers[random].transfer(winner_payout);
                winner_count +=1;
                winners[winner_count] = gamblers[random];
                // launch the event with the announce
                Announce_winner(this,gamblers[random],winner_payout);
                // sends 0.2 ethers to GiveDirectly in production
                // 0x512c3FCccdEFDa5D58E188b1AF39893e5D147aA3.transfer(givedirectly_payout);
                // Fake Give Directly address (Ropsten)
                0xd60406B842Ba7bCA8E83aF189e2A1bc96b24072B.transfer(givedirectly_payout);
                //reset the counter
                player_count = 0;
                // reset the addresses
                gamblers[1] = 0;
                gamblers[2] = 0;
                gamblers[3] = 0;
                gamblers[4] = 0;
                gamblers[5] = 0;

                }}
            }
        }