const { expect } = require("chai");
const { ethers } = require("hardhat");

const masterOracle = "0x59911722350361aC0C1BB200283D71baB482eed3"
const pJar = "0x9Cae10143d7316dF417413C43b79Fb5b44Fa85e2"
const lpToken = "0x8f93Eaae544e8f5EB077A1e09C1554067d9e2CA8"
const spell = "0x3E6648C5a70A150A88bCE65F4aD4d506Fe15d2AF"
const weth = "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1"


const deployedOracle = "0x4955592BE28b26aCf4E9D2670D27d696141B5Ab8"
const fakeOracle = "0x89D4F9Fbd7EAeDB6209E9706A94Ae1fAdc6A414E"
const originalRariOracle = "0x59911722350361aC0C1BB200283D71baB482eed3"
const cToken = "0x6976D1C008310E734C99c5Ea787C6467BB3cf26d"

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Oracle = await ethers.getContractFactory("PickleUniLPOracle");
    const oracle = await Oracle.deploy(masterOracle);
    await oracle.deployed();

    console.log("oracle address", oracle.address)

    console.log("list spell")
    await oracle.setFakeCToken(spell)
    console.log(await oracle.fakeCToken(spell))
    console.log("list weth")
    await oracle.setFakeCToken(weth)
    console.log(await oracle.fakeCToken(weth))    

    console.log("list pjar as ctoken - so we can have a fake ctoken")
    await oracle.setFakeCToken(pJar)
    console.log("query fake ctoken address")
    const cpJar = await oracle.fakeCToken(pJar)
    console.log({cpJar})

    console.log("check lp price")
    console.log((await oracle.getLPFairPrice(lpToken)).toString())

    console.log("checking price")
    const price = await oracle.getUnderlyingPrice(cpJar)

    console.log(price.toString())
  });

  it.only("fake oracle", async function () {
    const Oracle = await ethers.getContractFactory("FakeAmpOracle");
    const oracle = await Oracle.deploy(originalRariOracle);
    await oracle.deployed();

    console.log(oracle.address)

    const realOracle = await Oracle.attach(originalRariOracle)
    console.log((await realOracle.getUnderlyingPrice(cToken)).toString())
    console.log((await oracle.getUnderlyingPrice(cToken)).toString())

    sd

    console.log("oracle address", oracle.address)

    console.log("list spell")
    await oracle.setFakeCToken(spell)
    console.log(await oracle.fakeCToken(spell))
    console.log("list weth")
    await oracle.setFakeCToken(weth)
    console.log(await oracle.fakeCToken(weth))    

    console.log("list pjar as ctoken - so we can have a fake ctoken")
    await oracle.setFakeCToken(pJar)
    console.log("query fake ctoken address")
    const cpJar = await oracle.fakeCToken(pJar)
    console.log({cpJar})

    console.log("check lp price")
    console.log((await oracle.getLPFairPrice(lpToken)).toString())

    console.log("checking price")
    const price = await oracle.getUnderlyingPrice(cpJar)

    console.log(price.toString())
  });  
});
