require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
          version: "0.5.16",
          settings: {
              optimizer: {
                  enabled: true,
                  runs: 200
              }
          }
      }
    ]    
  },

  networks: {
/*
    hardhat: {
        accounts: accountsList,
        gas: 10000000,  // tx gas limit
        blockGasLimit: 12500000, 
        gasPrice: 20000000000,
    },
*/
    hardhat: {
        forking: {
        url: "https://arb1.arbitrum.io/rpc"
        //url: "https://rpc.ftm.tools"
        }
    },

    arb: {
      url: "https://arb1.arbitrum.io/rpc",
      //gas: 10000000,  // tx gas limit
      //accounts: [""]
  },         

    rinkeby: {
      url: "https://rinkeby.arbitrum.io/rpc",
      //gas: 10000000,  // tx gas limit
      //accounts: [""]
  },    

  }  
};
