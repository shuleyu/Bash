#!/bin/bash

#==============================================================
#
# This script return the standard deviation of input file to the screen.
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
#include<stdlib.h>
#include<assert.h>
#include<math.h>

int main(int argc, char *argv[]){

    FILE   *fp;
    double Aver,tmpval;
	int count,Count;

    fp=fopen("$1","r");
    assert(fp);

    Aver=0.0;
    Count=0;
    while (fscanf(fp,"%lf",&tmpval)==1){
		Aver+=tmpval;
		Count++;
    }
    fclose(fp);

	Aver/=Count;

	double *val=(double *)malloc(Count*sizeof(double));
    fp=fopen("$1","r");
	for (count=0;count<Count;count++){
		fscanf(fp,"%lf",&val[count]);
	}
    fclose(fp);

	tmpval=0;
	for (count=0;count<Count;count++){
        tmpval+=pow((val[count]-Aver),2);
	}
	printf("%.12lf\n",sqrt(tmpval/(Count-1)));

	free(val);
    return 0;
}
EOF

gcc tmpfile_$$.c -lm -o tmpfile_$$.out

./tmpfile_$$.out

rm tmpfile_$$.*


exit 0
