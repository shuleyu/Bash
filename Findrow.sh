#!/bin/bash

#==============================================================
# This script return the columns of input file according to the
# key words.
#
# Inputs : $1 ---- INFILE.
#          $2 ---- Key column file.
#
# Output : Stdout
#
# Shule Yu
# Nov 05 2014
#==============================================================

awk '{print $1}' $1 > tmpfile_$$

rm -f tmpfile1_$$
while read key
do
    INFO=`grep -n -w ${key} tmpfile_$$ 2>/dev/null`
    if [ $? -ne 0 ]
    then
        continue
    fi
    echo "${INFO}" >> tmpfile1_$$
done < $2

if ! [ -e tmpfile1_$$ ]
then
    exit 0
fi

awk 'BEGIN {FS=":"} {print $1}' tmpfile1_$$ > tmpfile_$$

while read Row
do
    awk -v R=${Row} 'NR==R {print $0}' $1
done < tmpfile_$$

rm -f tmpfile1_$$ tmpfile_$$

exit 0
