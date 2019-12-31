#!/bin/bash

#==============================================================
#
# This script plot (quick and dirty) a waveform.
#
# Inputs : $@ ---- Infiles, two columns for each file.
#
# Output : ./$@_$$.pdf
#
#==============================================================

if [ $# -lt 1 ]
then
	echo "In `basename $0`, use infile as \$1..."
	exit 1
fi

rm -f .gmtcommands4 .gmtdefaults4

while [ "$1" != "" ]
do

    INFILE=$1
    OUTFILE=${INFILE}_$$.ps

    XMIN=`minmax -m -C ${INFILE} | awk '{print $1}'`
    XMAX=`minmax -m -C ${INFILE} | awk '{print $2}'`
    YMIN=`minmax -m -C ${INFILE} | awk '{print $3}'`
    YMAX=`minmax -m -C ${INFILE} | awk '{print $4}'`

#     XMIN=-30
#     XMAX=30
#     YMIN=-1.1
#     YMAX=1.1

    XINC=`echo "${XMAX} ${XMIN}" | awk '{printf "%.4lf",($1-$2)/10}'`
    YINC=`echo "${YMAX} ${YMIN}" | awk '{printf "%.4lf",($1-$2)/10}'`

#     psxy ${INFILE} -JX9.5i/6i -R40/85/-0.6/1.5 -X1i -Y1i -m -W0.5p -Ba5/a0.25 > ${OUTFILE}
#     psxy ${INFILE} -JX6.5i/1i -R-30/30/-1/1 -X1i -Y1i -m -W0.5p -Ba10/a0.5 > ${OUTFILE}
    psxy ${INFILE} -JX9.5i/6i -R${XMIN}/${XMAX}/${YMIN}/${YMAX} -X1i -Y1i -m -W0.5p -Ba${XINC}/a${YINC} > ${OUTFILE}

    ps2pdf ${OUTFILE}
    rm -f ${OUTFILE} .gmtcommands4 .gmtdefaults4

    shift
done

exit 0
