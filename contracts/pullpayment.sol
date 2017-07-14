
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
