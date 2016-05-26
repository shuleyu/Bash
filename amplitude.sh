#!/bin/bash

#==============================================================
#
# This script return the amplitude of input file to the screen.
#
# Input file should be one column of numbers.
#
# Inputs : $1 ---- file name.
#
# Output : Stdout
#
#==============================================================

command -v minmax >/dev/null 2>&1

if [ $? -eq 0 ]
then

    minmax -C $1 | awk '{printf "%.4e\n%.4e\n%.4e\n%.4e\n",$1,$2,-$1,-$2}' | minmax -C | awk '{print $2}'

else

    cat > tmpfile_$$.c << EOF
#include<stdio.h>
#include<assert.h>
#include<math.h>

int main(int argc, char *argv[]){

    FILE   *fp;
    double Maxval,tmpval;

    fp=fopen("$1","r");
    assert(fp);

    Maxval=0.0;
    while (fscanf(fp,"%lf",&tmpval)==1){
        if (fabs(tmpval)>Maxval){
            Maxval=fabs(tmpval);
        }
    }
    printf("%.12lf\n",Maxval);

    fclose(fp);
    return 0;
}
EOF

    gcc tmpfile_$$.c -lm -o tmpfile_$$.out

    ./tmpfile_$$.out

    rm tmpfile_$$.*

fi


exit 0
