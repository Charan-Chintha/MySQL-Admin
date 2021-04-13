delimiter $$

drop procedure if exists SP_Grant_table_schema_user;
create procedure SP_Grant_table_schema_user(in USER_NAME varchar(50),in TABLE_NAME varchar(100),in GRANTINFO varchar(100),in SCHEMA_NAME varchar(50))
begin

declare V_Count int;
declare V_Data text;
declare V_Inc int;
declare V_Cnt int default 0 ;

select "*****************Checking the given USER_NAME,TABLE_NAME,SCHEMA_NAME***********************" as '>>>>>>>PREVALIDATION';

select count(1) into V_Count from information_schema.tables it ,mysql.user mu where it.TABLE_SCHEMA=SCHEMA_NAME and it.TABLE_NAME=TABLE_NAME and mu.user=USER_NAME;

if(V_Count > 0)  then

select concat("USER: ",USER_NAME," SCHEMA: ",SCHEMA_NAME ," TABLE: ",TABLE_NAME," Grant info: ",GRANTINFO) as '>>>>>>>INPUT DETAILS';

select count(1) into V_Inc from mysql.user where user=USER_NAME and (host !='%' or host not like '172.20.%' or host not like '172.27.%' );

while( V_Cnt <= V_Inc ) do

select concat("GRANT ",GRANTINFO," ON ",SCHEMA_NAME,".",TABLE_NAME," TO '",USER_NAME,"'@'",Host,"';") into V_Data FROM mysql.user where user=USER_NAME LIMIT V_Cnt,1;

 SET @sqlv=V_Data;
 PREPARE stmt FROM @sqlv;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;

set V_Cnt=V_Cnt+1;
 
end while;

else

select "Given schema/table/user not available";

end if;
end
$$
delimiter ;