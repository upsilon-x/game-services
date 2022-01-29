# Ethereum Game Services
This is a truffle project that hosts all of the smart contracts that the ethereum
game services use.

### Note on Repository Relations
While each project should be able to run a mainnet on their own, a complete developer 
environment on the local system will need all four projects. This is the first project
that you should set up.  
Furthermore, all repositories should be within the same folder. It is best if the 
repositories related to this project are the only repositories within said folder:  
```
git-projects
    - ethereum-game-services
        - game-services
        - fb-functions
        - interface
        - dashboard
```

## Initial Setup
First, install dependencies: `npm install`.  
Please download the desktop ganache application [here](https://trufflesuite.com/ganache/) 
if you have not already. You're literally a psycopath if you think the CLI is better.  
Spin up a workspace and make sure that the RPC server is at HTTP://127.0.0.1:7545. The 
truffle config expects this, and so do the other projects.  

If at this point the truffle project has not been spun up yet, please do so with:  
```
npm run development
migrate
```

## First Spinup
Before doing the following, you should already have ganache & a migration set up.  
To make sure that you are using the right contracts in the rest of your projects, try to 
run this command: `npm run createjson`. It will take all of the deployed contracts' 
addresses and put them in a json outside the parent directory, which can be accessed by 
other projects.

### Setting up Metamask
You'll need to set up metamask to use it on the local instance. In metamask:
```
Settings -> Networks -> Add Network

Network Name: Ganache Local
New RPC URL: http://127.0.0.1:7545
Chain ID: 1337
```
After saving, you will want to import an account into metamask. Go into truffle, choose 
the second or third account, get their private key, and use it to import a new account 
within metamask.

## Using Truffle
Within `npm run development`, you gain access to more commands. The following commands will be 
assume that you are within it.  

Nothing special has to be done to ensure that the data within your developer blockchain is 
saved. Ganache will automatically do it for you when you close and reopen the workspace.  

After you migrate, you shouldn't have to do it again. But, if you mess up a contract's state, 
you should be able to migrate again: `migrate --reset all`. Be careful. Using migrate will reset 
all of your contracts.  

If you are running tests, please follow 
[this guide](https://trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript.html). 
To run tests, simply run `test`.  

### Interacting with Smart Contracts
You can use the truffle console as if it is a javascript conslole with web3.js installed. 
You can interact with an instance like so:  
```
let nftInstance = await ProjectNFT.deployed()
nftInstance.address // gets the address
await nftInstance.ownerOf(0) // await any functions you wish to interact with
```
Learn more about using truffle 
[here](https://trufflesuite.com/docs/truffle/getting-started/interacting-with-your-contracts.html).


