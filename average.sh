#!/bin/bash

#==============================================================
#
# This script return the averge of input file to the screen.
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
#include<math.h>

int main(int argc, char *argv[]){

    FILE   *fp;
    double Aver,tmpval;
	int Count;

    fp=fopen("$1","r");
    assert(fp);

    Aver=0.0;
    Count=0;
    while (fscanf(fp,"%lf",&tmpval)==1){
		Aver+=tmpval;
		Count++;
    }
    printf("%.12lf\n",Aver/Count);

    fclose(fp);
    return 0;
}
EOF

gcc tmpfile_$$.c -lm -o tmpfile_$$.out

./tmpfile_$$.out

rm tmpfile_$$.*


exit 0
