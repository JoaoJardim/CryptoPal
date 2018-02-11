var CryptoPal = artifacts.require("CryptoPal");

module.exports = function(deployer) {
    deployer.deploy(CryptoPal);
}