#!/bin/bash

#=================================================================
# This script contact globalcmt.org and get the CMT solution for
# input earthquake.
#
# Inputs : $1 ---- EQ name (e.g. 200608250044)
#
# Output : Stdout. Strike1, Dip1, Rake1, Strike2, Dip2, Rake2
#
# Shule Yu
# Feb 06 2018
#=================================================================


if [ $# -ne 1 ]
then
	echo "In `basename $0`, $1 is not a valid Eq name..."
	exit 1
fi

EQ=${1}

YYYY=`echo ${EQ} | cut -c1-4`
MM=`echo ${EQ} | cut -c5-6`
DD=`echo ${EQ} | cut -c7-8`

SearchURL="http://www.globalcmt.org/cgi-bin/globalcmt-cgi-bin/CMT5/form?itype=ymd&yr=${YYYY}&mo=${MM}&day=${DD}&otype=ymd&oyr=${YYYY}&omo=${MM}&oday=${DD}&jyr=1976&jday=1&ojyr=1976&ojday=1&nday=1&lmw=0&umw=10&lms=0&ums=10&lmb=0&umb=10&llat=-90&ulat=90&llon=-180&ulon=180&lhd=0&uhd=1000&lts=-9999&uts=9999&lpe1=0&upe1=90&lpe2=0&upe2=90&list=2"

curl ${SearchURL} 2>/dev/null | grep ${EQ} | head -n 1 | awk '{print $3,$4,$5,$6,$7,$8}'

exit 0
