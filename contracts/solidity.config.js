module.exports = {
  compilers: {
    solc: {
      version: "0.8.0", // Change this to the appropriate Solidity version you're using
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
  sourceDirectory: "./",
  remappings: ["@openzeppelin/=./node_modules/@openzeppelin/"],
};
