>$1_diff_alters.sql
>$1_create.sql
passwd='abc@1234'

# in the below command give ur db password in place of abc@1234
mysqldbcompare --server1=root:${passwd}@localhost:3306   --difftype=sql --run-all-tests $1:$2 > $1_diff.sql

cat $1_diff.sql|sed "s/COMMENT[=]'.*'//"|sed -n '/ALTER TABLE/,/;/p'|sed '/,$/{$!{N;s/,\nAUTO_INCREMENT[=][0-9]*//;ty;P;D;:y}}'|sed 's/AUTO_INCREMENT[=][0-9]*//' > $1_alt_diff.sql

egrep -rv 'DROP FOREIGN KEY|ADD CONSTRAINT|DROP COLUMN|INDEX' $1_alt_diff.sql | tr -d ';' | sed -e 's/ALTER TABLE/;ALTER TABLE/g' | tr '\n' ' ' | sed -e 's/\;/\n\;/g' | sed 's/^;//g' | sed 's/.$/;/g'|sed 's/COLLATE[=][a-zA-Z0-9_,]*//'|sed "s/# WARNING:[#.a-zA-Z0-9_' ]*//"|sed "s/[, ]*;/;/"|sed "s/[ ]*;/ ;/"|tr -s ' '|sed "s/from from/\`from\` \`from\`/"|sed "s/to to/\`to\` \`to\`/"|sed "s/AFTER from /AFTER \`from\` /"|sed "s/AFTER to /AFTER \`to\` /"|sed "s/\([']*\)\(CURRENT_TIMESTAMP[()0-9]*\)\1/\2 /g"  > $1_alters.sql



echo "set foreign_key_checks=0;" >$1_diff_alters.sql

while read line
do
a=$(echo "${line}"|awk '{print $4}')
if [[ $a != ";" ]]
then
echo ${line} >> $1_diff_alters.sql
fi
done < $1_alters.sql

if [[ $? -eq 0 ]]
then
echo "Alters are ready"
else
echo "Alters not ready"
fi


cat $1_diff.sql|sed -n "/Objects in server1.$2/,/-----------------------/p"|grep "TABLE"|cut -d':' -f 2|awk '{$1=$1;print}' > test.txt

echo "set foreign_key_checks=0;" > $1_create.sql

while read line
do
mysql -uroot -p${passwd} -e "show create table $2.${line}\G"|sed -n '/CREATE/,$p'|sed 's/Create Table: //'|sed 's/AUTO_INCREMENT[=][0-9]*//'|sed 's/DEFAULT CHARSET[=][a-zA-Z0-9_]*//' >> $1_create.sql
echo ";" >> $1_create.sql
done < test.txt


if [[ $? -eq 0 ]]
then
echo "Creates are ready"
else
echo "Creates not ready"
fi

rm -rf $1_alt_diff.sql
rm -rf test.txt
rm -rf $1_alters.sql