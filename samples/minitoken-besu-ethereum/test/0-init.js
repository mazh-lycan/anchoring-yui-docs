const SCUseCase = artifacts.require("SCUseCase");

module.exports = async (callback) => {
  const accounts = await web3.eth.getAccounts();
  const alice = accounts[1];
  const mintAmount = 100;

  const scusecase = await SCUseCase.deployed();
  const block = await web3.eth.getBlockNumber();
  await scusecase.setUserHash(alice, "0xe31822911e580b5ff47d83bebb177a69a78e076baad60a15aac6d4bbb904afc2");
  const suhEvent = await scusecase.getPastEvents("SetUserHash", { fromBlock: block });
  console.log(suhEvent);

  callback();
};
