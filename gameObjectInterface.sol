pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface GameObjectInterface {
    function takeTheAttack(int8 _power) external;
}
