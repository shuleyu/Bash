#!/bin/bash

#==============================================================
#
# This script convert longitude to -180 ~ 180 deg.
#
# Input file should be one column of numbers.
#
# Inputs : $1 ---- file name.
#
# Output : Stdout
#
#==============================================================

cat > tmpfile_$$.c << EOF
#include<stdio.h>
#include<assert.h>

int main(int argc, char *argv[]){

    FILE   *fp;
    fp=fopen("$1","r");
    assert(fp);

	double lon;
    while (fscanf(fp,"%lf",&lon)==1){

		if (lon>=0){
			lon-=360*((int)(lon/360));
		}
		else{
			lon+=360*(1+(int)(-lon/360));
		}

		if (lon>180){
			lon-=360;
		}

		printf("%.12lf\n",lon);
	}

    fclose(fp);
    return 0;
}
EOF

gcc tmpfile_$$.c -o tmpfile_$$.out

./tmpfile_$$.out

rm tmpfile_$$.*

exit 0
