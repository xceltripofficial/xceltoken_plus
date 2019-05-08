const {shouldFail} = require('openzeppelin-test-helpers');

const testConst = require('./testconstants');
const config = require('../utils/CommonConst.json');
const tokenContract = require('./tokencontract');

const BN = require('bn.js');

require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bn')(BN))
    .should();

contract('XcelLab', accounts => {

    beforeEach(async function () {
        this.token = await tokenContract(accounts);
    });

    describe('token attributes', function () {
        it('has correct name', async function () {
            const name = await this.token.name();
            name.should.equal(config.name);
        });

        it('has correct symbol', async function () {
            const symbol = await this.token.symbol();
            symbol.should.equal(config.symbol);
        });

        it('has correct decimals', async function () {
            const decimals = await this.token.decimals();
            decimals.should.be.a.bignumber.that.equals(config.decimals);
        });

        it('has correct totalSupply', async function () {
            const totalSupply = await this.token.totalSupply();
            testConst.totalSupply.eq(totalSupply);
        });

        it('has correct teamAddress', async function () {
            const teamAddress =  await this.token.teamAddress();
            assert.equal(teamAddress, accounts[1], "address should be same");
        });

        it('has correct teamSupply', async function () {
            const teamSupply = await this.token.balanceOf(accounts[1]);
            testConst.teamSupply.eq(teamSupply);
        });

        it('has correct publicAddress', async function () {
            const publicSaleAddress = await this.token.publicSaleAddress();
            assert.equal(publicSaleAddress, accounts[2], "address should be same");
        });

        it('has correct publicSaleSupply', async function () {
            const publicSaleSupply = await this.token.balanceOf(accounts[2]);
            testConst.publicSaleSupply.eq(publicSaleSupply);
        });

        it('has correct foundationAddress', async function () {
            const foundationAddress = await this.token.foundationAddress();
            assert.equal(foundationAddress, accounts[3], "address should be same");
        });

        it('has correct foundationSupply', async function () {
            const foundationSupply = await this.token.balanceOf(accounts[3]);
            testConst.foundationSupply.eq(foundationSupply);
        });

        it('has correct loyaltyAddress', async function () {
            const loyaltyAddress = await this.token.loyaltyAddress();
            assert.equal(loyaltyAddress, accounts[4], "address should be same");
        });

        it('has correct loyaltySupply', async function () {
            const loyaltySupply = await this.token.balanceOf(accounts[4]);
            testConst.loyaltySupply.eq(loyaltySupply);
        });

        it('has correct reserveAddress', async function () {
            const reserveAddress =  await this.token.reserveAddress();
            assert.equal(reserveAddress, accounts[5], "address should be same");
        });


        it('has correct reserveSupply', async function () {
            const reserveSupply = await this.token.balanceOf(accounts[5]);
            testConst.reserveSupply.eq(reserveSupply);
        });

        it('should deploy token with paused as false', async function () {
            assert.equal(await this.token.paused(), false, 'paused should be initialized to false');
        });

        it('should fail to transfer this token to this contract address', async function () {
            await shouldFail.reverting(this.token.transfer(this.token.address, new BN(1000000), {from: accounts[1]}));
        });
    });

});
