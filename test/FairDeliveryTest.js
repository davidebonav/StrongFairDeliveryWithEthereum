const { expect } = require("chai");
const { loadFixture, setBalance } = require("@nomicfoundation/hardhat-network-helpers");


describe("FairDelivery contract", function () {

  async function deployFairDeliveryFixture() {
    const FairDelivery = await ethers.getContractFactory("FairDelivery");
    const [owner, addr1, addr2, addr3] = await ethers.getSigners();

    let minFee = 10;

    // To deploy our contract, we just have to call Token.deploy() and await
    // its deployed() method, which happens onces its transaction has been
    // mined.
    const fairDeliveryContract = await FairDelivery.deploy(minFee);
    await fairDeliveryContract.deployed();

    return { FairDelivery, fairDeliveryContract, owner, addr1, addr2, addr3, minFee };
  }

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

  describe("is Payable", function () {
    it("The constructor should set the minimum fee correctly", async function () {
      let minFee = 15;

      const { FairDelivery } = await loadFixture(deployFairDeliveryFixture);
      const fairDeliveryContract = await FairDelivery.deploy(minFee);

      expect(await fairDeliveryContract.minimumFee()).to.equal(minFee);
    });

    describe("test setMinimumFee method", function () {
      it("Only the owner should can change the minimum fee", async function () {
        const { fairDeliveryContract, addr1 } = await loadFixture(deployFairDeliveryFixture);
        expect(fairDeliveryContract.connect(addr1).setMinimumFee(10)).to.be.revertedWith("Ownable: caller is not the owner");
      });

      it("The method must correctly change the minimum fee", async function () {
        let newMinFee = 100;

        const { fairDeliveryContract, owner } = await loadFixture(deployFairDeliveryFixture);

        await fairDeliveryContract.connect(owner).setMinimumFee(newMinFee);
        expect(await fairDeliveryContract.minimumFee()).to.equal(newMinFee);
      });
    });

    describe("test payTo method", function () {
      it("Only the owner should can call the method", async function () {
        const { fairDeliveryContract, addr1 } = await loadFixture(deployFairDeliveryFixture);
        expect(fairDeliveryContract.connect(addr1).payTo(addr1.address, 10, true)).to.be.revertedWith("Ownable: caller is not the owner");
      });

      it("The balance of the contract must be greater than the amount to be paid", async function () {
        const { fairDeliveryContract, owner } = await loadFixture(deployFairDeliveryFixture);
        expect(fairDeliveryContract.connect(owner).payTo(owner.address, 10, true)).to.be.revertedWithCustomError(fairDeliveryContract, "NotEnoughBalance").withArgs("The amount must be less than or equal to the current balance", /* the min fee */ 0);
      });

      it("The method must correctly pay to the amount tu the address", async function () {
        const { fairDeliveryContract, owner, addr1 } = await loadFixture(deployFairDeliveryFixture);
        let amount = 100;

        await setBalance(fairDeliveryContract.address, amount);
        expect(await fairDeliveryContract.connect(owner).payTo(addr1.address, 10, true)).to.changeEtherBalance(addr1, amount);
      });
    });

    describe("test payToOwner method", function () {
      it("Only the owner should can call the method", async function () {
        const { fairDeliveryContract, addr1 } = await loadFixture(deployFairDeliveryFixture);
        expect(fairDeliveryContract.connect(addr1).payToOwner(10)).to.be.revertedWith("Ownable: caller is not the owner");
      });

      it("The balance of the contract must be greater than the amount to be paid", async function () {
        const { fairDeliveryContract, owner } = await loadFixture(deployFairDeliveryFixture);
        expect(fairDeliveryContract.connect(owner).payToOwner(10)).to.be.revertedWithCustomError(fairDeliveryContract, "NotEnoughBalance").withArgs("The amount must be less than or equal to the current balance", /* the min fee */ 0);
      });

      it("The method must correctly pay to the amount tu the address", async function () {
        const { fairDeliveryContract, owner, addr1 } = await loadFixture(deployFairDeliveryFixture);
        let amount = 100;

        await setBalance(fairDeliveryContract.address, amount);
        expect(await fairDeliveryContract.connect(owner).payToOwner(10)).to.changeEtherBalance(addr1, amount);
      });
    });

  });
});
