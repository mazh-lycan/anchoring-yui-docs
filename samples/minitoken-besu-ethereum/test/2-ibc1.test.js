const Anchoring = artifacts.require("Anchoring");

contract("Anchoring", (accounts) => {
  it("should have anchored holder alice n hash sha256 cacnea", () =>
    Anchoring.deployed()
      .then((instance) => instance.getHashAnchored(accounts[1]))
      .then((balance) => {
        assert.equal(balance.valueOf(), "0xe31822911e580b5ff47d83bebb177a69a78e076baad60a15aac6d4bbb904afc2", "info wasnt anchored");
      }));
});
