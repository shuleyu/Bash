#!/bin/bash

# ==========================================================
# This code deal with triplication within taup calculation.
# Will only keep the first arrival result.
# If there is no path for this source-receiver pair, return 1.
#
# Input : $1 ---- path file generated by TauP.
# Output: stdout.
#
# Shule Yu
# May 28 2014
# ==========================================================

q=`head -n 1 $1`

if ! [ -z "$q" ]
then  # if ${PHASE} exist
    
    cp $1 tmpfile_$$

    a=`grep -n ">" tmpfile_$$ | awk 'BEGIN {FS=":"} {print $1}'`
    t1=`echo $a|awk '{print $1}'`
    t2=`echo $a|awk '{print $2}'`

    if ! [ -z "$t2" ]
    then # we do have triplication.

        ed -s tmpfile_$$ > /dev/null << EOF
$t2,$ d
1 d
wq
EOF
    else # we don't have triplication
        ed -s tmpfile_$$ > /dev/null << EOF
1 d
wq
EOF
    fi

    cat tmpfile_$$

    rm tmpfile_$$ 2>/dev/null

    exit 0

else

    exit 1
fi
