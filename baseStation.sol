pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'gameObject.sol';
import 'baseSatationInterface.sol';
import 'warUnit.sol';


contract BaseStation is GameObject, BaceStationInterface {
    address[] units;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        lives = 20;
    }
    
    function addUnit(address _unit) public onlyOwner override {
        tvm.accept();
        units.push(_unit);
    }

    function deleteUnit(address _unit) public onlyOwner{
        tvm.accept();
        uint unit_index_for_delete;

        for (uint i = 0; i < units.length; i++){
            if (units[i] == _unit) {
                unit_index_for_delete = i;
            }
        }
    
        units[unit_index_for_delete] = units[units.length - 1];
        WarUnit(units[units.length - 1]).dieFromBaseStation(address(this));
        units.pop();
    }

    function die(address _enemyAddress) override internal {
        tvm.accept();
        for (uint8 i = 0; i < units.length; i++){
            WarUnit(units[i]).dieFromBaseStation(_enemyAddress);
        }
        selfdestruct(_enemyAddress);
    }

    function getLives() public view returns (uint8) {
        tvm.accept();
        return lives;
    }
}