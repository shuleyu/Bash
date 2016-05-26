#!/bin/bash

#==============================================================
# This script paste files together. Before that, check how many 
# rows within these files to avoid a unwanted error.
#
# The first line of the input file indicate the column name.
#
# Inputs : $@ ---- input ASCII file names.
#
# Output : Stdout
#
# Shule Yu
# May 29 2015
#==============================================================

Filenames=$@

NR=`wc -l < ${1}`

for file in ${Filenames}
do
    if [ `wc -l < ${file}` -ne ${NR} ]
    then
        echo "In Paste.sh: Warnning, ${file} has different number of rows !" 1>&2
        echo "${NR} / `wc -l < ${file}`" 1>&2
        continue
    fi

done

paste ${Filenames}

exit 0
