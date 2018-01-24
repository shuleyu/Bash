#!/bin/bash

#==============================================================
#
# This script plot (quick and dirty) a waveform.
#
# Inputs : $1 ---- Infile, two columns.
#
# Output : ./$1_$$.pdf
#
#==============================================================

if [ $# -ne 1 ]
then
	echo "In `basename $0`, use infile as \$1..."
	exit 1
fi

rm -f .gmtcommands4 .gmtdefaults4

INFILE=$1
OUTFILE=${INFILE}_$$.ps

XMIN=`minmax -m -C ${INFILE} | awk '{print $1}'`
XMAX=`minmax -m -C ${INFILE} | awk '{print $2}'`
YMIN=`minmax -m -C ${INFILE} | awk '{print $3}'`
YMAX=`minmax -m -C ${INFILE} | awk '{print $4}'`

psxy ${INFILE} -JX9.5i/6i -R${XMIN}/${XMAX}/${YMIN}/${YMAX} -X1i -Y1i -m -W0.5p -B > ${OUTFILE}

ps2pdf ${OUTFILE}
rm -f ${OUTFILE} .gmtcommands4 .gmtdefaults4

exit 0
