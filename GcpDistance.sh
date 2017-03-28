#!/bin/bash

#==============================================================
#
# This script return the great circle distance of input locations.
#
# Inputs : $1 ---- evlo.
#          $2 ---- evla.
#          $3 ---- stlo.
#          $4 ---- stla.
#
# Output : Stdout
#
#==============================================================

cat > tmpfile_$$.c << EOF
#include<stdio.h>
#include<stdlib.h>
#include<math.h>

double gcpdistance(double lo1,double la1, double lo2,double la2){

    double a,b,C,x,y;

    a=la1*M_PI/180;
    b=la2*M_PI/180;
    C=(lo1-lo2)*M_PI/180;

    y=sqrt(pow((cos(a)*sin(b)-sin(a)*cos(b)*cos(C)),2)+pow(cos(b)*sin(C),2));
    x=sin(a)*sin(b)+cos(a)*cos(b)*cos(C);

    return 180/M_PI*atan2(y,x);
}

int main(int argc, char *argv[]){

	double lo1,la1,lo2,la2;
	lo1=atof(argv[1]);
	la1=atof(argv[2]);
	lo2=atof(argv[3]);
	la2=atof(argv[4]);
	
    printf("%.3lf\n",gcpdistance(lo1,la1,lo2,la2));

    return 0;
}
EOF

gcc tmpfile_$$.c -lm -o tmpfile_$$.out

./tmpfile_$$.out $1 $2 $3 $4

rm -f tmpfile_$$.*

exit 0
