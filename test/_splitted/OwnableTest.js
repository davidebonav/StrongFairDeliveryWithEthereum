const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { deployFairDeliveryFixture } = require("./utils");

describe("is Ownable", function () {
  it("Should set the right owner", async function () {
    const { fairDeliveryContract, owner } = await loadFixture(deployFairDeliveryFixture);
    expect(await fairDeliveryContract.owner()).to.equal(owner.address);
  });

  describe("test transferOwnership method", function () {
    it("Should transfer the ownership of the contract correctly", async function () {
      const { fairDeliveryContract, owner, addr1 } = await loadFixture(deployFairDeliveryFixture);
      await fairDeliveryContract.connect(owner).transferOwnership(addr1.address);
      expect(await fairDeliveryContract.owner()).to.equal(addr1.address);
    });

    it("Only the owner should can transfer the ownership of the contract", async function () {
      const { fairDeliveryContract, addr1 } = await loadFixture(deployFairDeliveryFixture);
      expect(fairDeliveryContract.connect(addr1).transferOwnership(addr1.address)).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should emit OwnershipTransferred events", async function () {
      const { fairDeliveryContract, owner, addr1 } = await loadFixture(deployFairDeliveryFixture);
      expect(await fairDeliveryContract.connect(owner).transferOwnership(addr1.address)).to.emit(fairDeliveryContract, "OwnershipTransferred").withArgs(owner.address, addr1.address);
    });
  });
});

