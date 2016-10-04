#!/bin/bash

#==============================================================
# This script replace the exact given word in an ascii file.
#
# Inputs   : $1 ---- The file.
#            $2 ---- Original word.
#            $2 ---- New word.
#
# Output   : Stdout
# ExitCode : 0  ---- replace is done at least once.
#            1  ---- original world is not found.
#            2  ---- Input error.
#
# Shule Yu
# Sep 28 2016
#==============================================================

INFILE="$1"
OldWord="$2"
NewWord="$3"

if ! [ -s "${INFILE}" ] || [ -z "${OldWord}" ] || [ -z "${NewWord}" ]
then
	exit 2
fi

grep -w ${OldWord} ${INFILE} > /dev/null 2>&1
if [ $? -ne 0 ]
then
	cat ${INFILE}
	exit 1
fi

ed -s ${INFILE} << EOF
,s/\<${OldWord}\>/${NewWord}/g
w tmpfile_$$
EOF

cat tmpfile_$$
rm -f tmpfile_$$

exit 0
