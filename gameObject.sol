pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'gameObjectInterface.sol';

contract GameObject is GameObjectInterface {
    uint8 public lives;
    uint8 defence;

    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(), 1337);
		tvm.accept();
		_;
	}


    function takeTheAttack(uint8 _power) external override virtual {
        tvm.accept();

        lives = lives - (defence - _power);

        if (checkForDeath()) {
            die(msg.sender);
        }
    }

    function getDefence() public returns (uint8) {
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