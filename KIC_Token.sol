// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract KIC is ERC20, ERC20Burnable{
    string private constant _name = "KIC TOKEN";
    string private constant _symbol = "KIC";
    uint64 private constant INITIAL_SUPPLY = 100000000000;

    address __owner;

    // Lock
    mapping (address => uint256) private lockAddress;
    address[] private addressLogArray;     

    constructor() ERC20(_name, _symbol) {
        __owner = msg.sender;
        _mint(msg.sender, INITIAL_SUPPLY * 10 ** decimals());

        //fncLockAddress(_team, (block.timestamp + (24 * 60 * 60 * 365 * 4)));
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        address sender = _msgSender();

        require(!isLockAddress(sender), "Lock Address");

        _transfer(sender, to, amount);
        return true;
    }

     function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();

        require(__owner == spender, "Not Owner");
        require(!isLockAddress(from), "Lock Address");

        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function fncLockAddress(address _lockAddress, uint256 _releaseTime) public {
        require(__owner == msg.sender, "Not Owner");

        lockAddress[_lockAddress] = _releaseTime;
        addressLogArray.push(_lockAddress); 
    }
    
    function getLockAddressTime(address _lockAddress) public view returns (uint) {
        return lockAddress[_lockAddress]; 
    }

    function isLockAddress(address _addr) public view returns (bool lock) {
        lock = false;

        if(lockAddress[_addr] > block.timestamp) {
            lock = true;
        }
    }
}