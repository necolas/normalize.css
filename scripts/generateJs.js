const fs = require('fs');
const path = require('path');
const input = path.resolve(__dirname, '../normalize.css');
const outputDir = path.resolve(__dirname, '../dist/');
const output = path.resolve(outputDir, './normalize.css.js');

let normalizeCss = fs.readFileSync(input, 'utf-8');
normalizeCss = normalizeCss.replace(/\`/g, '\\`');

const content = `module.exports = \`${normalizeCss}\``;

if (!fs.existsSync(outputDir)){
  fs.mkdirSync(outputDir);
}

fs.writeFileSync(output, content);