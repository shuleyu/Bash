#!/bin/bash

#=============================================================
# This script add/update columns for a Table1. New information
# comes from Table2.
#
# 1. Only update rows in Table1, use $4 as the key.
#
# 2. If there's new columns in Table2, add them to Table1,
#    other rows for these new columns becomes NULL.
#
# 3. If there's same columns in Table2 as in Table1, update
#    info in Table2 into Table1 (overwrite info in Table1)
#
# Inputs : $1  ----  Database Name.
#          $2  ----  Table1 Name.
#          $3  ----  Table2 Name.
#          $4  ----  Name of the Key Field.
#
# Shule Yu
# Mar 22 2016
#=============================================================


# Check inputs.
if [ $# -ne 4 ]
then
    echo "Need 4 input parameters."
    exit 1;
fi

# Check database's existance.
mysql -u shule << EOF
create database if not exists ${1};
EOF

# Check Table2's existance.
mysql -u shule ${1} > /dev/null 2>&1 << EOF
select 1 from ${3} limit 1;
select ${4} from ${3} limit 1;
EOF
if [ $? -ne 0 ]
then
	echo "In `basename $0`: Table2 doesn't exist/have key column!"
	exit 1;
fi

# Check Table1's existance.
# If it doesn't exist, copy Table2 as Table1.

mysql -u shule ${1} > /dev/null 2>&1 << EOF
select 1 from ${2} limit 1;
EOF

if [ $? -ne 0 ]
then
	mysql -u shule ${1} > /dev/null << EOF
create table ${2} as select * from ${3};
alter table ${2} add primary key (${4});
EOF
	exit 0;
fi

# Check Table1.Key column's existance.
mysql -u shule ${1} > /dev/null 2>&1 << EOF
select ${4} from ${2} limit 1;
EOF

if [ $? -ne 0 ]
then
	echo "In `basename $0`: Table1 doesn't have key column!"
	exit 1;
fi

# Get column names (Field) from Table1 and Table2:
mysql -u shule ${1} > tmpfile_$$ << EOF
select column_name from information_schema.columns where table_schema="${1}" and table_name="${2}";
EOF
awk 'NR>1 {print $0}' tmpfile_$$ | sort > tmpfile_table1_colname_$$

mysql -u shule ${1} > tmpfile_$$ << EOF
select column_name from information_schema.columns where table_schema="${1}" and table_name="${3}";
EOF
awk 'NR>1 {print $0}' tmpfile_$$ | sort > tmpfile_table2_colname_$$


# Find new/same columns.
comm -1 -3 tmpfile_table1_colname_$$ tmpfile_table2_colname_$$ > tmpfile_newcol_$$
comm -1 -2 tmpfile_table1_colname_$$ tmpfile_table2_colname_$$ | awk -v A=${4} '{if ($1!=A) print $1}' > tmpfile_samecol_$$


# Update same columns.
if [ -s tmpfile_samecol_$$ ]
then
	rm -f tmpfile_sql_$$
	for entry in `cat tmpfile_samecol_$$`
	do
		echo "update ${2} t1, ${3} t2 set t1.${entry}=t2.${entry} where t1.${4}=t2.${4};" >> tmpfile_sql_$$
	done
	mysql -u shule ${1} < tmpfile_sql_$$
fi

# Update new columns.
if ! [ -s tmpfile_newcol_$$ ]
then
	rm -f tmpfile*$$
	exit 0
fi

cat > tmpfile_sql_$$ << EOF
drop table if exists NewTable$$;
create table NewTable$$ as ( select ${2}.* 
EOF

for entry in `cat tmpfile_newcol_$$`
do
	echo ", ${3}.${entry}" >> tmpfile_sql_$$
done

cat >> tmpfile_sql_$$ << EOF
from ${2} left join ${3} on ${2}.${4}=${3}.${4});
alter table NewTable$$ add primary key (${4});
EOF

# Update Table name.
echo "rename table ${2} to OldTable$$;" >> tmpfile_sql_$$
echo "rename table NewTable$$ to ${2};" >> tmpfile_sql_$$
echo "drop table OldTable$$;" >> tmpfile_sql_$$

mysql -u shule ${1} < tmpfile_sql_$$

rm -f tmpfile*$$
exit 0
