pragma solidity >=0.6.0 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Wallet {

    //Torna safemath disponivel para todos os uint 256 types
    using SafeMath for uint256;

    //Armazenar informaçoes dos tokens para poder interagir com seus contratos
    struct Token {
        bytes32 ticker;
        address tokenAddress;
    }

    modifier tokenExist(bytes32 ticker) {
        require(tokenMapping[ticker] != address(0), "Token not listed!");
        _;
    }

    mapping(bytes32 => Token) public tokenMapping;
    bytes32[] public tokenList;

    // Utiliza-se byte32 para o ticker do TOKEN para poder perfornmar comparações de string
    // Mapping dos balances dos diferentes usuarios de acordo com o token
    mapping(address => mapping(bytes32 => uint256)) public balances;

    function addToken(bytes32 ticker, address tokenAddress) external {
        tokenMapping[ticker] = Token(ticker, tokenAddress);
        tokenList.push(ticker);
    }

    function deposit(uint amount, bytes32 ticker) tokenExist(ticker) external {
        IERC20(tokenMapping[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][ticker] += balances[msg.sender][ticker].add(amount); 

    }

    function withdraw(uint amount, bytes32 ticker) tokenExist(ticker) external {

        require(balances[msg.sender][ticker] >= amount, "Balance not sufficient!");
        balances[msg.sender][ticker] = balances[msg.sender][ticker].sub(amount); 
        IERC20(tokenMapping[ticker].tokenAddress).transfer(msg.sender, amount);
    }
}