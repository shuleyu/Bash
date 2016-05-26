#!/bin/bash

set -a
SRCDIR=`pwd`

# ===========================================================
# Make a Matlab style subplots, using GMT.
#
# Shule Yu
# May 31 2015
# ===========================================================

WORKDIR=~/tmp_plot
VERTICNUM=3
HORIZNUM=4
VERTICPER="0.8"
HORIZPER="0.8"
PLOTORIENT=""

if [ -z ${PLOTORIENT} ]
then
    YMOVE="8.1"
    PLOTVERTIC="8"
    PLOTHORIZ="10"
else
    YMOVE="10.1"
    PLOTVERTIC="10"
    PLOTHORIZ="8"
fi

mkdir -p ${WORKDIR}/tmpdir_$$
cd ${WORKDIR}/tmpdir_$$
trap "rm -r ${WORKDIR}/tmpdir_$$ 2>/dev/null; exit 1" SIGINT EXIT

hskip=`echo "${PLOTVERTIC}/${VERTICNUM}" | bc -l`
wskip=`echo "${PLOTHORIZ}/($((HORIZNUM-1))+${HORIZPER})" | bc -l`
height=`echo "${hskip}*${VERTICPER}" | bc -l`
width=`echo "${wskip}*${HORIZPER}" | bc -l`

gmtset PAPER_MEDIA = letter
gmtset ANNOT_FONT_SIZE_PRIMARY = 8p
gmtset LABEL_FONT_SIZE = 9p
gmtset LABEL_OFFSET = 0.1c
gmtset GRID_PEN_PRIMARY = 0.25p,200/200/200

# Plot.
OUTFILE=test.ps


# Title.
title="EQ. Info and more."
PROJ="-JX${PLOTHORIZ}i/0.3i"
REG="-R-1/1/-1/1"
pstext ${REG} ${PROJ} -X0.6i -Y${YMOVE}i ${PLOTORIENT} -N -K > ${OUTFILE} << EOF
0 0 10 0 0 CB ${title}
EOF

psxy -J -R -Y-${YMOVE}i -O -K >> ${OUTFILE} << EOF
EOF

psxy -J -R -Y${PLOTVERTIC}i -O -K >> ${OUTFILE} << EOF
EOF

psxy -J -R -Y-${height}i -O -K >> ${OUTFILE} << EOF
EOF

# Plots.
for count in `seq 1 $((VERTICNUM*HORIZNUM))`
do
    if [ -e ${SRCDIR}/plot_${count}.sh ]
    then
        ${SRCDIR}/plot_${count}.sh
    fi

    if [ $((count%HORIZNUM)) -eq 0 ]
    then
        psxy -J -R -X`echo "-$((HORIZNUM-1))*${wskip}" | bc -l`i -Y-${hskip}i -O -K >> ${OUTFILE} << EOF
EOF
    else
        psxy -J -R -X${wskip}i -O -K >> ${OUTFILE} << EOF
EOF
    fi

done

# Make PDF.
psxy -J -R -O >> ${OUTFILE} << EOF
EOF

ps2pdf ${OUTFILE} ${WORKDIR}/test.pdf

exit 0
