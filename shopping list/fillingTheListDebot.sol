pragma ton-solidity >=0.35.0;
import 'baseDebot.sol';
import 'shoppingListDebotBase.sol';

contract FillingTheListDebot is BaseDebot, BaseShopingListDebot {
    uint amount;

    function _menu() internal override {
        string sep = '----------------------------------------';
        PurchaseSummary summary = ShoppingList(m_address).summary();
        Menu.select(
            format(
                "You have {}/{}/{} (completed/incompleted/total price) purchases",
                summary.numberOfCompletedPurchases,
                summary.numberOfIncompletedPurchases,
                summary.totalPrice
            ),
            sep,
            [
                MenuItem("Create purchase", "", tvm.functionId(createPurchase)),
                MenuItem("Show purchases list", "", tvm.functionId(showPurchases)),
                MenuItem("Create purchase", "", tvm.functionId(deletePurchase))
            ]
        );
    }


    function createPurchase(uint index) public {
        index = index;
        Terminal.input(tvm.functionId(completePurchase_), "Enter purchase name", false);
    }

    function createPurchase_(string value) public {
        amount = stoi(value);
        index = index;
        Terminal.input(tvm.functionId(completePurchase__), "Enter ammount", false);
    }

    function createPurchase__(string value) public {
        uint256 num = stoi(value);
        amount = uint(num);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).createPurchase {
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(_menu()),
            onErrorId: tvm.functionId(onError)
        }(name, amount);
    }
}