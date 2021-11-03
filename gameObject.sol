pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'gameObjectInterface.sol';

contract GameObject is GameObjectInterface {
    int8 public lives;
    int8 defence;

    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(), 1337);
		tvm.accept();
		_;
	}


    function takeTheAttack(int8 _power) external override {
        tvm.accept();

        int8 damage = _power - defence;

        if (damage > 0) {
            lives = lives - (damage);
        }

        if (checkForDeath()) {
            die(msg.sender);
        }
    }

    function getDefence() public returns (int8) {
        tvm.accept();
        return defence;
    }

    function checkForDeath() internal view returns(bool) {
        return lives == 0 ? true : false;
    }

    function die(address enemyAddress) internal virtual {
        tvm.accept();
        selfdestruct(enemyAddress);
    }
}