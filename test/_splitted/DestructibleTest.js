const { expect } = require("chai");
const { loadFixture, setBalance } = require("@nomicfoundation/hardhat-network-helpers");
const { deployFairDeliveryFixture } = require("./utils");


describe("is Destructible", function () {

  it("Only the owner should can destroy the contract", async function () {
    const { fairDeliveryContract, addr1 } = await loadFixture(deployFairDeliveryFixture);
    expect(fairDeliveryContract.connect(addr1).destroy()).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("The contract should destroy properly", async function () {
    const { fairDeliveryContract, owner } = await loadFixture(deployFairDeliveryFixture);
    await fairDeliveryContract.connect(owner).destroy();
    expect(await ethers.provider.getBalance(fairDeliveryContract.address)).to.equal(0)
    expect(await ethers.provider.getCode(fairDeliveryContract.address)).to.equal("0x")
  });

  it("The balance of the contract should be sent to the owner", async function () {
    const { fairDeliveryContract, owner } = await loadFixture(deployFairDeliveryFixture);

    let balance = 1000;
    await setBalance(fairDeliveryContract.address, balance);
    expect(await fairDeliveryContract.connect(owner).destroy()).to.changeEtherBalance(owner, balance);
  });
});
