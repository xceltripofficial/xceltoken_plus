pragma solidity >=0.4.25 <0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract XcelLab is ERC20Detailed, ERC20Pausable, ERC20Burnable, Ownable {

  // 50 Billion total supply
  uint256 public constant INITIAL_SUPPLY =50 * (10**9) * (10**18);

  // team supply 10%
  uint256 public teamSupply = 5 * (10**9) * (10**18);

  // public sale supply 30%
  uint256 public publicSaleSupply = 15 * (10**9) * (10**18);

  // Foundation supply 30%
  uint256 public foundationSupply = 15 * (10**9) * (10**18);

  // Loyalty supply 15%
  uint256 public loyaltySupply = 7.5 * (10**9) * (10**18);

  // Reserve supply 15%
  uint256 public reserveSupply = 7.5 * (10**9) * (10**18);

  address public teamAddress;
  address public publicSaleAddress;
  address public foundationAddress;
  address public loyaltyAddress;
  address public reserveAddress;

//safety measure , disputes are visible here and is expected to resolve via comnuty concensus.
  mapping(address => bool) internal lockedAccounts;


  constructor(string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address _teamAddress,
    address _publicSaleAddress,
    address _foundationAddress,
    address _loyaltyAddress,
    address _reserveAddress)
    ERC20Detailed(_name, _symbol, _decimals)
    public {
      //mint all tokens to contract owner address;
      _mint(msg.sender, INITIAL_SUPPLY);

      teamAddress = _teamAddress;
      publicSaleAddress = _publicSaleAddress;
      foundationAddress = _foundationAddress;
      loyaltyAddress = _loyaltyAddress;
      reserveAddress = _reserveAddress;

      transfer(_teamAddress, teamSupply);
      transfer(_publicSaleAddress, publicSaleSupply);
      transfer(_foundationAddress,foundationSupply);
      transfer(_loyaltyAddress,loyaltySupply);
      transfer(_reserveAddress,reserveSupply);

  }

  event TokensBought(address indexed _to, uint256 _totalAmount, bytes4 _currency, bytes32 _txHash);

  event LockedAccount(address indexed _targetAddress);

  event UnlockedAccount(address indexed _targetAddress);

  modifier onlyPublicSaleAdmin() {
      require(msg.sender == publicSaleAddress);
      _;
  }

  //Allow contract owner to burn token
  //To burn token, it first needs to be transferred to the owner
  function burn(uint256 _value)
    public
    onlyOwner {
      super.burn(_value);
  }

  /**
  external function for publicSaleSupply
  **/

    function buyTokens(address _to, uint256 _totalWeiAmount, bytes4 _currency, bytes32 _txHash)
      external
      onlyPublicSaleAdmin
      returns(bool) {
          require(_totalWeiAmount > 0 && balanceOf(msg.sender) >= _totalWeiAmount);
          require(transfer(_to, _totalWeiAmount));
          emit TokensBought(_to, _totalWeiAmount, _currency, _txHash);
          return true;
      }

   /** lock the Account for security
  **/

  function lockAccount(address _targetAddress) external onlyOwner returns(bool){
      require(_targetAddress != address(0));
      require(!lockedAccounts[_targetAddress]);
      //can't lockyourself out
      require(owner() != _targetAddress);
      lockedAccounts[_targetAddress] = true;
      emit LockedAccount(_targetAddress);
      return true;
  }

  /** unlock the Account for security
  **/

  function unlockAccount(address _targetAddress) external onlyOwner returns(bool){
      require(_targetAddress != address(0));
      require(lockedAccounts[_targetAddress]);
      delete lockedAccounts[_targetAddress];
      emit UnlockedAccount(_targetAddress);
      return true;
  }

  /** get locked/unlocked status of the account
  **/

  function isAddressLocked(address _targetAddress) public view returns(bool){
     //if address not in mapping , returns false
     return lockedAccounts[_targetAddress];
  }



  /** hold the transfer for locked account
  **/

    function transfer(address to, uint256 value) public returns (bool) {
        require(!lockedAccounts[msg.sender]);
        require(to != address(this)); // do not accept transfer to the contract address
        super.transfer(to, value);
        return true;
    }

  // Sending Ether to this contract will cause an exception,
  // because the fallback function does not have the `payable`
  // modifier.
  function() external {  }

}
