pragma solidity >=0.6.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Wallet.sol";

contract Dex is Wallet {

    //Tipo um booleano para indicar o tipo de ordem
    enum Side {
        BUY,
        SELL
    }

    struct Order {
        uint id;
        address trader;
        Side buyOrder;
        bytes32 ticker;
        uint amountl;
        uint price;
    }
    
    //Esse mapping cria um ordem book para BUY e outro para SELL para cada ticker
    mapping(bytes32 => mapping(uint => Order[])) orderBook;

    function getOrderBook(bytes32 ticker, Side side) view public returns(Order[] memory) {
        return orderBook[ticker][uint(side)];
    }

    // function createLimitOrder() {

    // }

}