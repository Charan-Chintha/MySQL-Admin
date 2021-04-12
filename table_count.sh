>output.txt
USER=user
PASSWORD='password'
HOST=localhost
schema_name=`mysql -u$USER -p$PASSWORD -h$HOST -Nse "select schema_name from information_Schema.schemata where schema_name not in('information_schema','mysql','performance_schema','tmp','test','innodb');"`
for db in $schema_name
do
	TABLE_LIST=`mysql -u$USER -p$PASSWORD -h$HOST -Nse "select table_name from information_Schema.tables where table_schema='${db}'"`
	for TABLE in $TABLE_LIST
	do
		mysql -u$USER -p$PASSWORD -h$HOST -Nse "SELECT CONCAT('DB IS $db AND $TABLE COUNT IS: ',COUNT(1)) FROM $db.$TABLE;" >>output.txt
	done
done



