#!/usr/bin/env nodejs
/* -*- coding: UTF-8, tab-width: 2 -*- */

const prettyMeta = require.resolve('eslint-formatter-pretty/package.json');
const prettyPath = require('path').resolve(prettyMeta, '..');

if (process.argv.length < 3) { process.argv.push('.'); }
process.argv.splice(2, 0, '--format=' + prettyPath);

process.on('exit', function displaySuccess(retval) {
  function hadNoOutput(chan) { return (process[chan].bytesWritten === 0); }
  if (hadNoOutput('stdout') && hadNoOutput('stderr')) {
    if (retval === 0) {
      console.log('+OK no messages');
    } else {
      console.error('-ERR code = ' + retval);
    }
  }
});

require('eslint/bin/eslint.js');
