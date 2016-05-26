#!/bin/bash

BASHCODEDIR=${0%/*}

#==============================================================
# This script read in a two column signal data (first column is
# time, second column is amplitude). Then find the peak within
# given time window; shift the time column center at the peak;
# flip/normalize amplitude according to the peak.
#
# Inputs : $1 ---- INFILE.
#          $2 ---- Time window center.
#          $3 ---- Time window half width.
#
# Output : Stdout
#
# Shule Yu
# Jul 23 2015
#==============================================================

if [ $# -ne 3 ]
then
    cat << EOF
    Usage:
           \$1 ---- Signal file (two columns).
           \$2 ---- Time window center.
           \$3 ---- Time window width.
EOF
    exit 1
fi

# Begin.

awk -v T=${2} -v W=${3} '{if (T-W<$1 && $1<T+W) print $1,$2}' $1 > tmpfile1_$$
awk '{print $2}' tmpfile1_$$ | sort -g > tmpfile_$$

AMP1=`head -n 1 tmpfile_$$`
AMP2=`tail -n 1 tmpfile_$$`
AMP=`echo "${AMP1} ${AMP2}" | awk '{if (-$1>$2) print $1; else print $2}'`


PeakTime=`awk -v A=${AMP} '{if ($2==A) print $1}' tmpfile1_$$ | head -n 1`

awk -v P=${PeakTime} -v A=${AMP} '{print $1-P,$2/A}' $1

# End.

rm -f tmpfile_$$ tmpfile1_$$

exit 0
