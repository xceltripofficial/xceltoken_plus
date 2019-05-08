const XcelLab = artifacts.require('XcelLab');
const config  = require ('../utils/CommonConst.json');

module.exports =  (accounts) => {
  return XcelLab.new(config.name,
      config.symbol,
      config.decimals,
      accounts[1],   // teamAddress
      accounts[2],   // publicSaleAddress
      accounts[3],   // foundationAddress
      accounts[4],   // loyaltyAddress
      accounts[5]);  // reserveAddress
}
