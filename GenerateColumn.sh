#!/bin/bash

#=================================================================
# This script generate one columns of given string.
#
# Inputs : $1 ---- Given string.
#          $2 ---- Number of rows.
#
# Output : Stdout
#
# Shule Yu
# Sep 09 2016
#=================================================================

if [ $2 -le 0 ]
then
	echo "In `basename $0`, $2 is not a valid number..."
	exit 1
fi

for count in `seq 1 $2`
do
	echo "$1"
done

exit 0
