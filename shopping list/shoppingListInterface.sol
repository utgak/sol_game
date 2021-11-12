pragma ton-solidity >= 0.35.0;
import 'purchase.sol';

interface IShoppingList {
    function getPurchases() external view returns (Purchase[] _purchases);
    function deletePurchase(uint id) external;
    function completeAPurchase(uint id, uint price) external;
    function createPurchase(string name, uint amount) external;
}