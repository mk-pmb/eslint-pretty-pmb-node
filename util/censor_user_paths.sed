#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-
s~/(home|mnt|Volumes?|Users?)/~\f<!path! /\1 >/~g
s~\f<!path! \S+ >\S*(/node_modules/)~/…\1~g
s~\f<!path! (\S+) >\S+~\1/…~g
