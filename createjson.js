console.log("*** INITIALIZING CREATE JSON ***");

const glob = require("glob");
const fs = require("fs");

// https://stackoverflow.com/a/31369011
glob("./build/contracts/*.json", function(err, files) {
  if(err) {
    console.log("cannot read the folder, something goes wrong with glob", err);
  }
  var addresses = {};
  let fileCount = 0;

  files.forEach(function(file, index) {
    fs.readFile(file, 'utf8', function (err, data) { // Read each file
      if(err) {
        console.log("cannot read the file, something goes wrong with the file", err);
      }
      var obj = JSON.parse(data);

      if(obj.networks["5777"] != null) {
        console.log("Adding " + obj.contractName);
        addresses[obj.contractName] = obj.networks["5777"].address;
      }

      fileCount++;
      if(fileCount == files.length) {
        console.log("*** READING FINISHED. BEGIN JSON WRITE ***",);
        fs.writeFile('../development-contracts.json', JSON.stringify(addresses), (err) => {
          if(err) throw err;
          console.log("*** WRITING FINISHED ***");
        });
      }
    });
  });

});
