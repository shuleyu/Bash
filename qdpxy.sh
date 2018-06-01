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
    XINC=`echo "${XMAX} ${XMIN}" | awk '{printf "%.2lf",($1-$2)/10}'`
    YINC=`echo "${YMAX} ${YMIN}" | awk '{printf "%.2lf",($1-$2)/10}'`

    psxy ${INFILE} -JX9.5i/6i -R${XMIN}/${XMAX}/${YMIN}/${YMAX} -X1i -Y1i -m -W0.5p -Ba${XINC}/a${YINC} > ${OUTFILE}

    ps2pdf ${OUTFILE}
    rm -f ${OUTFILE} .gmtcommands4 .gmtdefaults4

    shift
done

exit 0
