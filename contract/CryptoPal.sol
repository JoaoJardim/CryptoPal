pragma solidity ^0.4.2;

contract SafeMath {
  function safeMul(uint a, uint b) internal pure returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeSub(uint a, uint b) internal pure returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c>=a && c>=b);
    return c;
  }
}

contract CryptoPal is SafeMath {
    mapping(address => uint) balances;
    mapping(address => mapping(string => uint256)) multiCoinBalances; //this is currently different from EtherDelta. Here, it's eth address, than coin, and then amount. Maybe change....

    address public admin;            //the admin address
    address public feeAccount;       //the account that will receive fees
    address public accountLevelsAddr;//the address of the AccountLevels contract
    // uint    public feeMake;       //percentage times (1 ether)
    // uint    public feeTake;       //percentage times (1 ether)
    // uint    public feeRebate;     //percentage times (1 ether)
    mapping (address => mapping (address => uint)) public tokens;    //mapping of token addresses to mapping of account balances (token=0 means Ether) <-- THIS IS GOOD
    mapping (address => mapping (bytes32 => bool)) public orders;    //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
    mapping (address => mapping (bytes32 => uint)) public orderFills;//mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
    
    event Deposit(address token, address user, uint amount, uint balance);
    event Withdraw(address token, address user, uint amount, uint balance);

    // Contract constructor. Sets important addresses, like the admin.
    function CryptoPal(address admin_, address feeAccount_, address accountLevelsAddr_/*, uint feeMake_, uint feeTake_, uint feeRebate_*/) public {
        admin = admin_;
        feeAccount = feeAccount_;
        accountLevelsAddr = accountLevelsAddr_;
        // feeMake = feeMake_;
        // feeTake = feeTake_;
        // feeRebate = feeRebate_;
    }

    // Functions to change important addresses. Only admin can do this (which is verified).
    function changeAdmin            (address admin_)             public {
      assert(msg.sender != admin);
      admin = admin_;
    }
    function changeAccountLevelsAddr(address accountLevelsAddr_) public {
      assert(msg.sender != admin);
      accountLevelsAddr = accountLevelsAddr_;
    }
    function changeFeeAccount       (address feeAccount_)        public {
      assert(msg.sender != admin);
      feeAccount = feeAccount_;
    }

    //////////////////////SINGLECOIN//////////////////////
    function checkBalance()                                       public constant returns(uint amount) {
        return balances[msg.sender];
    }   
    function checkFriendBalance(address friend)                   public constant returns(uint amount) {
        return balances[friend];
    } 
    function depositAmount     (uint    amount)                   public          returns(bool confirmation) {
        //balances[msg.sender] = balances[msg.sender] + amount;
        balances[msg.sender] = safeAdd(balances[msg.sender], amount);
        return true;
    }
    function withdrawAmount    (uint    amount)                   public          returns(bool confirmation) {
        if (balances[msg.sender]>=amount) {
            //balances[msg.sender] = balances[msg.sender] - amount;
            balances[msg.sender] = safeSub(balances[msg.sender], amount);
            return true;
        }
        return false;
    }
    function sendMoney         (uint    amount, address toAdress) public          returns(bool confirmation) {
        if (balances[msg.sender] >= amount) {
            //balances[msg.sender] = balances[msg.sender] - amount;
            balances[msg.sender] = safeSub(balances[msg.sender], amount);
            //balances[toAdress] = balances[toAdress] + amount;
            balances[toAdress] = safeAdd(balances[toAdress], amount);
            return true;
        }
        return false;
    }
    
    //////////////////////MULTICOIN//////////////////////
    function checkBalanceMultiCoin      (string coin)                                   public constant returns(uint amount) {
        return multiCoinBalances[msg.sender][coin];
    }
    function checkFriendBalanceMultiCoin(address friend, string coin)                   public constant returns(uint amount) {
        return multiCoinBalances[friend][coin];
    }
    function depositAmountMultiCoin     (uint    amount, string coin)                   public          returns(bool confirmation) {
        //multiCoinBalances[msg.sender][coin] = multiCoinBalances[msg.sender][coin] + amount;
        multiCoinBalances[msg.sender][coin] = safeAdd(multiCoinBalances[msg.sender][coin], amount);
        return true;
    }
    function withdrawAmountMultiCoin    (uint    amount, string coin)                   public          returns(bool confirmation) {
        if (multiCoinBalances[msg.sender][coin] >= amount) {
            //multiCoinBalances[msg.sender][coin] = multiCoinBalances[msg.sender][coin] - amount;
            multiCoinBalances[msg.sender][coin] = safeSub(multiCoinBalances[msg.sender][coin], amount);
            return true;
        }
        return false;
    }
    function sendMoneyMultiCoin         (uint    amount, address toAdress, string coin) public          returns(bool confirmation) {
        if (multiCoinBalances[msg.sender][coin] >= amount) {
            //multiCoinBalances[msg.sender][coin] = multiCoinBalances[msg.sender][coin] - amount;
            multiCoinBalances[msg.sender][coin] = safeSub(multiCoinBalances[msg.sender][coin], amount);
            //multiCoinBalances[toAdress]  [coin] = multiCoinBalances[toAdress]  [coin] + amount;
            multiCoinBalances[toAdress]  [coin] = safeAdd(multiCoinBalances[toAdress]  [coin], amount);
            return true;
        }
        return false;
    }
}