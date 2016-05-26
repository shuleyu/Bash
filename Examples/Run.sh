#!/bin/bash


BASHCODEDIR=`pwd`/..

# ${BASHCODEDIR}/amplitude.sh amplitude_infile

# ${BASHCODEDIR}/normalize.sh normalize_infile

# ${BASHCODEDIR}/prem_velocity.sh P 2891
# ${BASHCODEDIR}/prem_velocity.sh S 2891

# cat > tmpfile_$$ << EOF
# PA71
# TEZI
# BTXA
# EOF
# ${BASHCODEDIR}/select_stations.sh select_stations_infile tmpfile_$$ -1
# ${BASHCODEDIR}/select_stations.sh select_stations_infile tmpfile_$$ 1

# saclst gcarc f `cat select_gcarc_az_baz_infile` | sort -k 2,2 -g
# echo ""
# ${BASHCODEDIR}/select_gcarc_az_baz.sh select_gcarc_az_baz_infile gcarc 95 100

# ${BASHCODEDIR}/select_sac_data.sh /home/shule/DATA/Merge.Mw5.5.100km/200608250044 R

# taup_path -deg 30 -ph S -h 50 -o tmpfile
# ${BASHCODEDIR}/FirstArrival_TauPPath.sh tmpfile.gmt

# keys="<Year> <Day>"
# ${BASHCODEDIR}/Findfield.sh Findfield_infile "${keys}"

cat > tmpfile_$$ << EOF
1992
2012
EOF
${BASHCODEDIR}/Findrow.sh Findrow_infile tmpfile_$$


rm tmpfile* 2>/dev/null

exit 0
