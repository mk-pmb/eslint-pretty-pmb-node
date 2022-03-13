#!/usr/bin/env node
/* -*- coding: UTF-8, tab-width: 2 -*- */

'use strict';

const prettyMeta = require.resolve('eslint-formatter-pretty/package.json');
const prettyPath = require('path').resolve(prettyMeta, '..');
const eslintBinPath = require('find-eslint-cli-bin-js-pmb')(require);

const { argv } = process;

(function maybeAddDot() {
  const ignOpts = [
    '--fix',
  ];
  const maybePaths = argv.slice(2).filter(a => !ignOpts.includes(a));
  if (maybePaths.length === 0) { argv.push('.'); }
}());

const scanExts = [
  '.js',
  '.jsm',
  '.json',
  '.jsx',
  '.mjs',
];
process.argv.splice(2, 0,
  '--ext', scanExts.join(','),
  '--format=' + prettyPath);

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

require(eslintBinPath); // eslint-disable-line import/no-dynamic-require
