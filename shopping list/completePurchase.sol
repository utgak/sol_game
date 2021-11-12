pragma ton-solidity >=0.35.0;
import 'baseDebot.sol';
import 'shoppingListDebotBase.sol';

contract CompletePurchaseDebot is BaseDebot, BaseShopingListDebot {
    uint price;
    uint PurchaseId;

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
                MenuItem("Finish purchase", "", tvm.functionId(completePurchase)),
                MenuItem("Show purchases list", "", tvm.functionId(showPurchases)),
                MenuItem("Delete purchase", "", tvm.functionId(deletePurchase))
            ]
        );
    }

    function completePurchase(uint32 index) public {
        index = index;
        if (summary.numberOfCompletedPurchases() + summary.numberOfIncompletedPurchases() > 0) {
            Terminal.input(tvm.functionId(createPurchase_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no purchases to complete");
            _menu();
        }
    }

    function completePurchase_(uint index) public {
        PurchaseId = index;
        Terminal.input(tvm.functionId(createPurchase__), "Enter price of one item", false);
    }

    function completePurchase__(string value) public {
        uint256 price = stoi(value);
        optional(uint256) pubkey = 0;

        IShoppingList(m_address).completePurchase {
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(PurchaseId, price);
    }
}