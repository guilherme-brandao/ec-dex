pragma solidity >=0.6.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Wallet.sol";

contract Dex is Wallet {

    using SafeMath for uint256;

    enum Side {
        BUY,
        SELL
    }

    struct Order {
        uint id;
        address trader;
        Side buyOrder;
        bytes32 ticker;
        uint amount;
        uint price;
    }

    uint public nextOrderId = 0;
    
    mapping(bytes32 => mapping(uint => Order[])) orderBook;

    function getOrderBook(bytes32 ticker, Side side) view public returns(Order[] memory) {
        return orderBook[ticker][uint(side)];
    }

    function createLimitOrder(Side side, bytes32 ticker, uint amount, uint price) public {
        if(side == Side.BUY) {
            require(balances[msg.sender][bytes32("ETH")] >= amount.mul(price), "You don't have this much ETH to buy these tokens!");
        } else if(side == Side.SELL) {
            require(balances[msg.sender][ticker] >= amount, "You dont have this much to sell!");
        }

        Order[] storage orders = orderBook[ticker][uint(side)];
        
        orders.push(
            Order(nextOrderId, msg.sender, side, ticker, amount, price)
        );

        uint i = orders.length > 0 ?  orders.length - 1 : 0;

        if(side == Side.BUY) {

            while(i > 0) {
                if(orders[i - 1].price > orders[i].price) {
                    break;
                }

                Order memory orderToMove = orders[i - 1];
                orders[i - 1] = orders[i];
                orders[i] = orderToMove;
                i--;
            }
        } else if(side == Side.SELL) {

            while(i > 0) {
                if(orders[i - 1].price < orders[i].price) {
                    break;
                }

                Order memory orderToMove = orders[i - 1];
                orders[i - 1] = orders[i];
                orders[i] = orderToMove;
                i--;
            }
        }
        nextOrderId++;

        return;
    }

    function createMarketOrder(Side side, bytes32 ticker, uint amount) {
        if(side == Side.BUY) {
            require(balances[msg.sender][bytes32("ETH")] >= amount.mul(price), "You don't have this much ETH to buy these tokens!");
        } else if(side == Side.SELL) {
            require(balances[msg.sender][ticker] >= amount, "You dont have this much to sell!");
        }
        

    }

}