#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
ulimit -v $(( ${ESLINT_MAX_MEMORY_MB:-1024} * 1024 ))
# 2025-11-04: Granting "mere" 512 MB caused malloc errors even for tiny files.

PKG_PATH="$(dirname -- "$(dirname -- "$( # <- busybox doesn't support -m
  readlink -f -- "$BASH_SOURCE")")")"
BEST_NODEJS="$(which node{js,.js,} |& grep -m 1 -Pe '^/')"
exec "$BEST_NODEJS" "$PKG_PATH"/elp.js "$@"; exit $?
