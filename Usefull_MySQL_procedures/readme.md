These procedures are help us to copy the bulk grants in Database. Conside below details </br>
Schema name: my_db</br>
table name: my_table</br>

<h2>SP_DB_grant Description: </h2>

This procedure will help us to copy the all exisitng grants of existing schema for newly created schema in same server. 

call SP_DB_grant('source schema','Target schema');</br>
source schema : Existing schema in the same server</br>
Target schema : newly created schema in same server</br>

<h2>SP_Grant_table_schema_user Description: </h2>

This procedure will help us on scenario. If we need to copy the select,insert,update privileges to the user and table.

call SP_Grant_table_schema_user('USER_NAME','TABLE_NAME','Select,Insert,Update','SCHEMA_NAME');</br>
It will execute the statements like as shown below</br>
Grant Select,Insert,Update on my_db.my_table to user_name@host1;</br>
Grant Select,Insert,Update on my_db.my_table to user_name@host2;</br>
Grant Select,Insert,Update on my_db.my_table to user_name@host3;</br>
