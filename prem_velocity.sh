#!/bin/bash

BASHCODEDIR=${0%/*}

#=====================================================================
#
#  This script extract velocity value from PREM file for P and S wave
#  at certain depth.
#
#  Inputs     : $1 ---- P/S
#               $2 ---- Depth.
#
#  Output     : Stdout with velocity value.
#
#  Shule Yu
#  Sept 12 2014
#
#=====================================================================

if [ "$1" = "P" ]
then
    echo `awk -v D=$2 '$1>=D {print $2}' ${BASHCODEDIR}/prem_profile.txt | head -n 1`
else
    echo `awk -v D=$2 '$1>=D {print $3}' ${BASHCODEDIR}/prem_profile.txt | head -n 1`
fi

exit 0
