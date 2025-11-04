#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
ulimit -v $(( ${ESLINT_MAX_MEMORY_MB:-1024} * 1024 ))
# 2025-11-04: Granting "mere" 512 MB caused malloc errors even for tiny files.

SELFPATH="$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")" # busybox
BEST_NODEJS="$(which node{js,.js,} |& grep -m 1 -Pe '^/')"
exec "$BEST_NODEJS" "$SELFPATH"/elp.js "$@"; exit $?
