#!/bin/bash


PROJ=-JX${width}i/${height}i
REG="-R-10/10/-10/10"

psxy ${REG} ${PROJ} -B -Sa0.2i -O -K >> ${OUTFILE} << EOF
-2 2
3 5
EOF



exit 0
