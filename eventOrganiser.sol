// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract organisize {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping (uint=>Event) public events;
    mapping (address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
        require(date>block.timestamp,"error 404");
        require(ticketCount>0,"error 404");
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
    }

    function buyTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0,"error 404");
        require(events[id].date>block.timestamp,"error 404");
        Event storage _event = events[id];
        require(msg.value==(_event.price * quantity),"error 404");
        require(_event.ticketRemain >= quantity,"error 404");
        _event.ticketRemain = _event.ticketRemain - quantity;
        tickets[msg.sender][id] = tickets[msg.sender][id] + quantity;
    }

    function transferTicket(uint id, uint quantity, address to) external {
        require(events[id].date!=0,"error 404");
        require(events[id].date>block.timestamp,"error 404");
        require(tickets[msg.sender][id]>=quantity,"error 404");
        tickets[msg.sender][id] = tickets[msg.sender][id] - quantity;
        tickets[to][id] = tickets[to][id] + quantity;
    }
}
