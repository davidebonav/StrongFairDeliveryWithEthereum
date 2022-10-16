const minFee = 10;

const nro = 12345;
const nrr = 67890;
const sub_k = 13456

const key = 111;

const nonce = ethers.utils.formatBytes32String("nonce");
const nonce_hah = ethers.utils.keccak256(nonce);
const nonce_errata = ethers.utils.formatBytes32String("nonce errata");

module.exports = { minFee, nro, nrr, sub_k, key, nonce, nonce_hah, nonce_errata }