delimiter $$
use mysql
drop procedure if exists SP_Table_Grant_Delete;
create procedure SP_Table_Grant_Delete(in SCHEMA_NAME varchar(50),in TARGET_TABLE varchar(100),in user1 varchar(100))
begin

declare V_Count int;
declare V_Data text;
declare V_Inc int;
declare V_Cnt int default 0 ;

select "*****************Checking the given SCHEMA, TABLE, USER details in DB***********************" as '>>>>>>>PREVALIDATION';


select count(1) into V_Count from information_schema.tables where TABLE_SCHEMA=SCHEMA_NAME and TABLE_NAME=TARGET_TABLE;

if(V_Count > 0)  then

select concat("SCHEMA: ",SCHEMA_NAME," TABLE: ",TARGET_TABLE," USER: ",user1) as '>>>>>>>INPUT DETAILS';

select count(1) into V_Inc from mysql.user where user=user1 and (host !='%' or host not like '172.20.%' or host not like '172.27.%' );

while( V_Cnt <= V_Inc ) do

SELECT CONCAT('GRANT DELETE ON ',SCHEMA_NAME,'.',TARGET_TABLE,' TO \'',user1,'\'@\'',Host,'\';') into V_Data FROM mysql.user where user=user1 LIMIT V_Cnt,1;


 SET @sqlv=V_Data;
 
 PREPARE stmt FROM @sqlv;

 EXECUTE stmt;

 DEALLOCATE PREPARE stmt;

 set V_Cnt=V_Cnt+1;
 
end while;

select "***********DELETE Grants copied******************" as '>>>>>>>OUTPUT DETAILS' union select concat("SCHEMA: ",SCHEMA_NAME," TABLE: ",TARGET_TABLE," USER: ",user1);

else

select "Given schema or table not available";

end if;

end
$$
delimiter ;
