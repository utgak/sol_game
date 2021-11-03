pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'gameObject.sol';
import 'baseSatationInterface.sol';


contract WarUnit is GameObject {
    address baseStation;
    int8 power;

    function dieFromBaseStation(address _address) public {
        tvm.accept();
        require(msg.sender == baseStation, 1337);
        die(_address);
    }

    function attack(GameObject object) public onlyOwner view {
        tvm.accept();
        object.takeTheAttack(power);
    }

    function getPower() public view returns (int8) {
        tvm.accept();
        return power;
    }
}