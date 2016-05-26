#!/bin/bash

#=====================================================================
#
#    This script select .sac files according to criterion provided
#    by user. Information is stored in header section of sac files.
#
#    Dependency : SAC ( saclst )
#
#    Inputs     : $1 ---- One file of .sac names (use absolute dir !)
#                 $2 ---- Criterion name.
#                 $3 ---- Criterion lower bound.
#                 $4 ---- Criterion upper bound.
#
#    Output     : Stdout with selected file names.
#
#    ( Criterions names : gcarc az baz )
#
#=====================================================================

saclst $2 f `cat $1` | awk -v R=$3 ' ( $2 >= R ) {print $0}' | awk -v R=$4 ' ( $2 <= R ) {print $0}' > tmpfile_$$

sort -g -k 2 tmpfile_$$ | awk '{print $1}' | sort -u

rm tmpfile_$$

exit 0
