const fs = require('fs');

// Read content of each JSON file
const circuitData = require('./circuit.json');
const outputData = require('./output.json');
const inputData = require('./input.json');

// Combine data from all files
const finalData = { ...circuitData, ...inputData, ...outputData };

// Write combined data to final.json
fs.writeFile('final.json', JSON.stringify(finalData, null, 2), (err) => {
  if (err) {
    console.error('Error writing final.json:', err);
  } else {
    console.log('final.json created successfully!');
  }
});
