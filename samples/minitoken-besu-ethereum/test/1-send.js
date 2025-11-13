const SCUseCase = artifacts.require("SCUseCase");

module.exports = async (callback) => {
  const accounts = await web3.eth.getAccounts();
  const alice = accounts[1];
  const bob = accounts[2];

  const sendAmount = 50;
  const port = "transfer";
  const channel = "channel-0";
  const timeoutHeight = 10000000;

  const scusecase = await SCUseCase.deployed();


  await scusecase.setCommParams(port, channel, timeoutHeight, {from: alice,
  });

  const anchored = await scusecase.anchorPair(alice, {
    from: alice,
  });
  console.log(anchored)


  const sendTransfer = await scusecase.getPastEvents("AnchorInfo", {
    fromBlock: 0,
  });
  console.log(sendTransfer);

  callback();
};
