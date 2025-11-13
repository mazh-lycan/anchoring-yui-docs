const Anchoring = artifacts.require("Anchoring");

contract("Anchoring", (accounts) => {
  it("should have sent holder n hash", async () => {
    const block = await web3.eth.getBlockNumber();
    Anchoring.deployed()
      .then((instance) =>
        instance.getPastEvents("SendTransfer", {
          filter: { to: accounts[1] },
          fromBlock: block,
        })
      )
      .then((evt) => {
        assert.equal(
          evt[0].args.amount.valueOf(),
          "0xe31822911e580b5ff47d83bebb177a69a78e076baad60a15aac6d4bbb904afc2",
          "holder n hash weren't anchored"
        );
      });
  });
});
