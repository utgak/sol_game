pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'shoppingListInterface.sol';
import 'ISLConstructor.sol';
import 'purchaseSummary.sol';

contract ShoppingList is ISLConstructor, IShoppingList {

    uint256 m_ownerPubkey;
    uint count;
    PurchaseSummary public summary;
    mapping(uint => Purchase) purchases;

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    constructor(uint256 pubkey) ISLConstructor(pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    function createPurchase(string name, uint amount) public override onlyOwner {
        tvm.accept();
        count++;
        purchases[count] = Purchase(count, name, now, amount, false, 0);
        summary.numberOfIncompletedPurchases += 1;
    }

    function completeAPurchase(uint id, uint price) public override onlyOwner {
        optional(Purchase) purchase = purchases.fetch(id);
        require(purchase.hasValue(), 102);
        tvm.accept();
        Purchase completedPurchase = purchase.get();
        uint _totalPrice = price * completedPurchase.amount;
        completedPurchase.isCompleted = true;
        completedPurchase.totalPrice = _totalPrice;
        purchases[id] = completedPurchase;
        summary.numberOfIncompletedPurchases -= 1;
        summary.numberOfCompletedPurchases += 1;
        summary.totalPrice += _totalPrice;
    }

    function deletePurchase(uint id) public override onlyOwner {
        require(purchases.exists(id), 102);
        tvm.accept();

        if (purchases[id].isCompleted) {
            summary.numberOfCompletedPurchases -= 1;
            summary.totalPrice -= purchases[id].totalPrice;
        } else {
            summary.numberOfIncompletedPurchases -= 1;
        }

        delete purchases[id];
    }

    function getPurchases() public override view returns (Purchase[] _purchases) {
        string name;
        uint32 createdAt;
        uint amount;
        bool isCompleted;
        uint totalPrice;

        for((uint id, Purchase purchase) : purchases) {
            name = purchase.name;
            createdAt = purchase.createdAt;
            amount = purchase.amount;
            isCompleted = purchase.isCompleted;
            totalPrice = purchase.totalPrice;
            _purchases.push(Purchase(id, name, createdAt, amount, isCompleted, totalPrice));
       }
    }
}