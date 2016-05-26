#!/bin/bash

BASHCODEDIR=${0%/*}

#==============================================================
#
# This script return normalized input file to the screen.
#
# Input file should be one column of numbers.
#
# Inputs : $1 ---- file name.
#
# Output : Stdout
#
#==============================================================

AMP=`${BASHCODEDIR}/amplitude.sh $1`

awk -v A=${AMP} '{ if (A==0) print 0; else print $1/A}' $1

exit 0
