#!/bin/bash

#==============================================================
# This script return the checked items in the input PDF files.
#
# Inputs : $@ ---- input PDFs' names.
#
# Output : $@.checked ---- files with checed items.
#          $@.unchecked ---- files with uncheced items.
#
# Dependence : pdftk.
#
# Shule Yu
# Dec 28 2014
#==============================================================

if [ $# -lt 1 ]
then
    exit 1
fi

BASHCODEDIR=${0%/*}

pdftk >/dev/null 2>&1 && local=1 || local=0

if [ ${local} -eq 1 ]
then

    while [ "$1" != "" ]
    do
        pdftk ${1} dump_data_fields | grep FieldValue | awk '{print $2}' | sort -u > ${1}.checked
        pdftk ${1} dump_data_fields | grep FieldName  | awk '{print $2}' | sort -u > tmpfile_$$
		comm -2 -3 tmpfile_$$ ${1}.checked | awk '{print $1}' > ${1}.unchecked
        shift
    done

	rm -f tmpfile_$$
    exit 0
else

	# Try to use a self-made code.
# 	CPPCODEDIR=${BASHCODEDIR}/../Fun.C++.c003
# 	${CPPCODEDIR}/compile.sh
# 	./DumpFields.out $@
# 	rm -f DumpFields.out

	# scp solution.

	# Use air
#     ssh shule@10.143.178.98 'mkdir ~/tmpdir_forcheckbox'
#     scp $@ shule@10.143.178.98:/Users/shule/tmpdir_forcheckbox
#     ssh shule@10.143.178.98 'source ~/.profile;ExtractCheckbox.sh /Users/shule/tmpdir_forcheckbox/*pdf'
#     scp shule@10.143.178.98:~/tmpdir_forcheckbox/*checked .
#     ssh shule@10.143.178.98 'rm -r /Users/shule/tmpdir_forcheckbox'

	# Use mini
    ssh    Shule@10.206.167.29 'mkdir ~/tmpdir_forcheckbox'
    scp $@ Shule@10.206.167.29:/Users/Shule/tmpdir_forcheckbox
    ssh    Shule@10.206.167.29 'source ~/.profile;ExtractCheckbox.sh /Users/Shule/tmpdir_forcheckbox/*pdf'
    scp    Shule@10.206.167.29:~/tmpdir_forcheckbox/*checked .
    ssh    Shule@10.206.167.29 'rm -r /Users/Shule/tmpdir_forcheckbox'

	# Use myssh
#     ssh -p 9022 shule@eq2.la.asu.edu 'mkdir ~/tmpdir_forcheckbox'
#     scp $@ -P 9022 shule@eq2.la.asu.edu:/Users/shule/tmpdir_forcheckbox
#     ssh -p 9022 shule@eq2.la.asu.edu 'source ~/.bashrc;cd /home/shule/tmpdir_forcheckbox;ExtractCheckbox.sh *pdf'
#     scp -P 9022 shule@eq2.la.asu.edu:~/tmpdir_forcheckbox/*checked .
#     ssh -p 9022 shule@eq2.la.asu.edu 'rm -r ~/tmpdir_forcheckbox'

	# Use myoffice
# 	ssh shule@10.206.166.34 'mkdir ~/tmpdir_forcheckbox'
# 	scp $@ shule@10.206.166.34:/home/shule/tmpdir_forcheckbox
# 	ssh shule@10.206.166.34 'source ~/.bashrc;cd /home/shule/tmpdir_forcheckbox;ExtractCheckbox.sh *pdf'
# 	scp shule@10.206.166.34:~/tmpdir_forcheckbox/*checked .
# 	ssh shule@10.206.166.34 'rm -r /home/shule/tmpdir_forcheckbox'

    exit 0
fi
