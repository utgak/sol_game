pragma ton-solidity >= 0.35.0;

struct Purchase {
    uint id;
    string name;
    uint32 createdAt;
    uint amount;
    bool isCompleted;
    uint totalPrice;
}