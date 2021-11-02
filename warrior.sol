pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'warUnit.sol';

contract Warrior is WarUnit {
    string objectType = 'warrior';
    uint8 id;
    constructor(BaceStationInterface _stationAdress) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _stationAdress.addUnit(address(this));
        baseStation = _stationAdress;
        power = 6;
        defence = 5;
        lives = 5;
    }
}