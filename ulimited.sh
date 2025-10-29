#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
ulimit -v $(( ${ESLINT_MAX_MEMORY_MB:-512} * 1024 ))
SELFPATH="$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")" # busybox
BEST_NODEJS="$(which node{js,.js,} |& grep -m 1 -Pe '^/')"
exec "$BEST_NODEJS" "$SELFPATH"/elp.js "$@"; exit $?
