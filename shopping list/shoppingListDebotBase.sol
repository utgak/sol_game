pragma ton-solidity >= 0.35.0;

abstract contract BaseShopingListDebot {

    function showPurchases(uint index) public view {
        index = index;
        optional(uint256) none;
        IShoppingList(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchases_),
            onErrorId: 0
        }();
    }

    function showPurchases_(Purchase[] _purchases) public {
        uint32 i;
        if (_purchases.length > 0 ) {
            Terminal.print(0, "Your purchases list:");
            for (i = 0; i < _purchases.length; i++) {
                Purchase purchase = _purchases[i];
                string completed;
                if (purchase.isCompleted) {
                    completed = '✓';
                    Terminal.print(0, format("{} {}  \"{}\"  at {}", purchase.id, completed, purchase.name, purchase.createdAt));
                } else {
                    completed = ' ';
                    Terminal.print(0, format("{} {}  \"{}\"  at {} total price {}", purchase.id, completed, purchase.name, purchase.createdAt, purchase.totalPrice));
                }
            }
        } else {
            Terminal.print(0, "Your purchases list is empty");
        }
        _menu();
    }

    function deletePurchase(uint index) public {
        index = index;
        PurchaseSummary summary = ShoppingList(m_address).summary();
        if (summary.numberOfCompletedPurchases() + summary.numberOfIncompletedPurchases() > 0) {
            Terminal.input(tvm.functionId(deleteTask_), "Enter task number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no tasks to delete");
            _menu();
        }
    }

    function deletePurchase_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint(num));
    }

    function _menu() virtual internal;
}