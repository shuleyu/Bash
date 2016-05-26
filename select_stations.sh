#!/bin/bash

#=====================================================================
# This script select .sac files according to given station names.
# Station name should exists within header section of sac files.
#
# Dependency : SAC file names have their station section:
#              e.g. 200707211327.KZ.KNDC.BHZ.sac
#
# Inputs     : $1 ---- One file of .sac names.
#              $2 ---- Station name file.
#              $3 ----
#                      -1 : reject these stations.
#                      1  : select these stations.
#
# Output     : Stdout with selected file names.
#
# Shule Yu
# Aug 12 2014
#=====================================================================

if ! [ -e ${2} ]
then
    cat $1
    exit 0
fi

if [ "$3" -eq "-1" ]
then
    cp $1 tmpfile_$$
    while read STNM
    do
        if [ -z `echo ${STNM}| cut -b 1` ] || [ `echo ${STNM}| cut -b 1` = ">" ]
        then
            continue
        fi
        cat tmpfile_$$ | grep -v "\.${STNM}\." > tmpfile1_$$
        mv  tmpfile1_$$ tmpfile_$$
    done < $2
else
    while read STNM
    do
        if [ -z `echo ${STNM}| cut -b 1` ] || [ `echo ${STNM}| cut -b 1` = ">" ]
        then
            continue
        fi
        cat $1 | grep "\.${STNM}\." >> tmpfile_$$
    done < $2
fi
cat tmpfile_$$ 2>/dev/null

rm tmpfile_$$ 2>/dev/null
exit 0
