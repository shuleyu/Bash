#!/bin/bash

#=====================================================================
#
#    This script reject .sac files according to criterion provided
#    by traffic file.
#
#    Dependency : SAC ( saclst )
#
#    Inputs     : $1 ---- One file of .sac names (use absolute dir !)
#                 $2 ---- Traffic file. (generated by t044)
#
#    Output     : Stdout with selected file names.
#
#=====================================================================

saclst evdp gcarc kstnm f `cat $1` | awk '{$2=$2/1000; print $0}' > tmpfile_$$
while read file evdp gcarc kstnm
do
    windows=`awk -v A=${evdp} 'NR>1 {if ($1>A) {$1="" ;print $0}}' $2 | head -n 1`
    window_num=`echo ${windows} | awk '{print $1}'`
    if [ "${window_num}" -eq 0 ]
    then
        echo ${file}
        continue
    fi

    count=0
    flag=0
    while [ "${count}" -lt ${window_num} ]
    do
        distmin=`echo ${windows} | awk -v A=$((2*count+2)) '{print $A}'`
        distmax=`echo ${windows} | awk -v A=$((2*count+3)) '{print $A}'`
        if [ `echo "${gcarc} < ${distmin}" | bc` -gt 0 ] || [ `echo "${gcarc} > ${distmax}" | bc` -gt 0 ]
        then
            flag=1
        else
            flag=0
            break
        fi
        count=$((count+1))
    done
    if [ "${flag}" -eq 1 ]
    then
        echo ${file}
    else
        echo ${kstnm} >> traffic_stations.txt
    fi

done < tmpfile_$$

rm tmpfile*$$

exit 0
