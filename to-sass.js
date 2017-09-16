'use strict';

var fs = require('fs');
var path = require('path');

const pkg = require('./package.json');

// Output file paths
var input = path.join(__dirname, pkg.main);
var output = path.join(__dirname, '_' + path.basename(pkg.main, '.css') + '.scss');

// Clean up Sass file if it's already there
try {
  fs.statSync(output);
  fs.unlink(output);
} catch(e) {
  // It's OK if this errors, it means the file doesn't exist
}

// Cpoy input file to output file
fs.writeFileSync(output, fs.readFileSync(input));
