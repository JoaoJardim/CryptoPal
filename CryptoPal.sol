pragma solidity ^0.4.0;

contract CryptoPal {
    mapping(address => uint) balances;
    mapping(address => mapping(string => uint256)) multiCoinBalances;
    
    function CryptoPal() public {
    }
    
    function checkBalance()                                        public constant returns (uint amount) {
        return balances[msg.sender];
    }
    
    function checkFriendBalance (address friend)                   public constant returns (uint amount) {
        return balances[friend];
    }
    
    function depositAmount      (uint    amount)                   public          returns (bool confirmation) {
        balances[msg.sender] = balances[msg.sender] + amount;
        return true;
    }
    
    function withdrawAmount     (uint    amount)                   public          returns (bool confirmation) {
        if (balances[msg.sender]>=amount) {
            balances[msg.sender] = balances[msg.sender] - amount;
            return true;
        }
        return false;
    }
    
    function sendMoney          (uint    amount, address toAdress) public          returns (bool confirmation) {
        if (balances[msg.sender] >= amount) {
            balances[msg.sender] = balances[msg.sender] - amount;
            balances[toAdress] = balances[toAdress] + amount;
            return true;
        }
        return false;
    }
    
    //////////////////////MULTICOIN//////////////////////
    
    function checkBalanceMultiCoin       (string coin)                                   public constant returns (uint amount) {
        return multiCoinBalances[msg.sender][coin];
    }
    
    function checkFriendBalanceMultiCoin (address friend, string coin)                   public constant returns (uint amount) {
        return multiCoinBalances[friend][coin];
    }
    
    function depositAmountMultiCoin      (uint    amount, string coin)                   public          returns (bool confirmation) {
        multiCoinBalances[msg.sender][coin] = multiCoinBalances[msg.sender][coin] + amount;
        return true;
    }
    
    function withdrawAmountMultiCoin     (uint    amount, string coin)                   public          returns (bool confirmation) {
        if (multiCoinBalances[msg.sender][coin] >= amount) {
            multiCoinBalances[msg.sender][coin] = multiCoinBalances[msg.sender][coin] - amount;
            return true;
        }
        return false;
    }
    
    function sendMoneyMultiCoin          (uint    amount, address toAdress, string coin) public          returns (bool confirmation) {
        if (multiCoinBalances[msg.sender][coin] >= amount) {
            multiCoinBalances[msg.sender][coin] = multiCoinBalances[msg.sender][coin] - amount;
            multiCoinBalances[toAdress]  [coin] = multiCoinBalances[toAdress]  [coin] + amount;
            return true;
        }
        return false;
    }
}