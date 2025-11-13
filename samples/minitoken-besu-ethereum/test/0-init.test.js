const SCUseCase = artifacts.require("MiniToken");

contract("SCUseCase", (accounts) => {
  it("should have set holder n hash", () =>
    SCUseCase.deployed()
      .then((instance) => instance.getHash(accounts[1]))
      .then((hash) => {
        assert.equal(hash.valueOf(), "0xe31822911e580b5ff47d83bebb177a69a78e076baad60a15aac6d4bbb904afc2", "hash was not set correctly");
      }));
});
