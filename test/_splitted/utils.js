const deployFairDeliveryFixture = async function () {
    const FairDelivery = await ethers.getContractFactory("FairDelivery");
    const [owner, addr1, addr2, addr3] = await ethers.getSigners();

    let minFee = 10;

    const fairDeliveryContract = await FairDelivery.deploy(minFee);
    await fairDeliveryContract.deployed();

    return { FairDelivery, fairDeliveryContract, owner, addr1, addr2, addr3, minFee };
}

module.exports = { deployFairDeliveryFixture };
