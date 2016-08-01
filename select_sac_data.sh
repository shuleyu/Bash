#!/bin/bash

#=====================================================================
#
#    This script select .sac files to make them "neat" for future use.
#
#    Assume .sac files are named in the following form:
#
#        ${EQ}.${NETWORK}.${STATION}.${COMP}.sac
#
#    Dependency : SAC ( saclst )
#
#    Inputs     : $1 ---- Directory name with .sac files.
#                 $2 ---- (Optional) Component name.
#
#    Output     : Stdout with selected file names.
#
#=====================================================================


DATADIR=$1
DATADIR=${DATADIR%%/}

# all possible component names:

CMP="[TBH]H[RTZ]"

# 1.1 reject segament files.
# 1.2 reject records incomplete in three components

for filename in ` find ${DATADIR}/ -iname "*${CMP}.sac" | sort `
do
    if [ ` ls ${filename%%?.sac}*[RTZ].sac |wc -l ` -eq 3 ]
    then
        echo $filename >> tmpfile_$$
    fi
done

# 2.1 keep the first set of records if one station reports to multiple net works.
# 2.2 if HH? and BH? are both collected, keep BH?
fileN=`wc -l tmpfile_$$ | awk '{print $1}'`
half_fileN=`echo "$fileN / 2" | bc`
awk -v N=${half_fileN} 'NR<N {print $0}' tmpfile_$$ > tmpfile_half1_$$
awk -v N=${half_fileN} 'NR>=N {print $0}' tmpfile_$$ > tmpfile_half2_$$
for infile in tmpfile_half1_$$ tmpfile_half2_$$
do
    saclst kstnm f `cat ${infile}` | awk '{print $2}' >> tmpfile1_$$
done

sort -u tmpfile1_$$ > tmpfile2_$$
rm tmpfile1_$$ 2>/dev/null

for stnm in ` cat tmpfile2_$$ `
do
    if [ `grep "\.${stnm}\.${CMP}\.sac" tmpfile_$$ |wc -l` -ne 3 ]
    then # naughty record.

        if [ `grep "\.${stnm}\.${CMP}\.sac" tmpfile_$$ | grep -v "HH[RTZ]\.sac" |wc -l` -gt 3 ]

        then # if # of BH? data for this station is greater than 3. get first set (3 records) of this station.

            grep "\.${stnm}\.${CMP}\.sac" tmpfile_$$ | grep -v "HH[RTZ]\.sac" | head -n 3 >> tmpfile1_$$

        else # seems we only have multiple sets of HH? data for this station. get the first set.

            grep "\.${stnm}\.${CMP}\.sac" tmpfile_$$ | head -n 3 >> tmpfile1_$$

        fi

    else # good record, output them directly.

        grep "\.${stnm}\.${CMP}\.sac" tmpfile_$$ >> tmpfile1_$$

    fi

done

if [ $# -eq 2 ]
then
    COMP=$2
    grep [${COMP}]\.sac$ tmpfile1_$$ | sort -u
else
    cat tmpfile1_$$ | sort -u
fi

rm tmpfile_$$ tmpfile1_$$ tmpfile2_$$ tmpfile_half1_$$ tmpfile_half2_$$ 2>/dev/null

exit 0
