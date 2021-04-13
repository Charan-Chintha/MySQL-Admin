delimiter $$
use mysql
drop procedure if exists SP_USER_GRANT$$

create procedure SP_USER_GRANT(in Old_USER varchar(100),in New_USER varchar(100))
begin

declare V_DBNAME varchar(50);
declare V_Val  varchar(1000);
declare V_in_Val varchar(1000);
declare V_cnt int;

select concat("Old user is : ",Old_USER," New user is : ",New_USER) as new; 

select ">>>>>>User table statements execution started!!!";

select count(1) into V_cnt from mysql.user where user=Old_USER;

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='user';  
 select replace(V_in_Val,"User,",concat('"',New_USER,'",')) into V_Val;

 set @t1 =concat("insert into mysql.user(",V_in_Val,") select ",V_Val," from mysql.user where User='",Old_USER,"';");



 PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

select "User table status : SUCCESS";
 else
 
  select "USER table privileges not available for this user. status : FAILED ";

 end if;

select ">>>>>>DB Table statements execution started!!!";

select count(1) into V_cnt from mysql.db where User=Old_USER;

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='db';  
 select replace(V_in_Val,"User,",concat('"',New_USER,'",')) into V_Val;

 set @t1 =concat("insert into mysql.db(",V_in_Val,") select ",V_Val," from mysql.db where User='",Old_USER,"';");


PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

select "DB table status : SUCCESS";
 else
 
  select "DB Table privileges not available for this user. status : FAILED";

 end if;
 
select ">>>>>>tables_priv statements execution started!!!" ;

select count(1) into V_cnt from mysql.tables_priv where User=Old_USER; 

 if V_cnt>0 then


 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='tables_priv';  
 select replace(V_in_Val,"User,",concat('"',New_USER,'",')) into V_Val;

 set @t1 =concat("insert into mysql.tables_priv(",V_in_Val,") select ",V_Val," from mysql.tables_priv where User='",Old_USER,"';");


PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

select "tables_priv table status : SUCCESS";

 else

 select "tables_priv privileges not available for this user. status : FAILED";

 end if;
 


select ">>>>>>procs_priv statements execution started!!!" ;

select count(1) into V_cnt from mysql.columns_priv where User=Old_USER; 

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='columns_priv';  
 select replace(V_in_Val,"User,",concat('"',New_USER,'",')) into V_Val;

 set @t1 =concat("insert into mysql.columns_priv(",V_in_Val,") select ",V_Val," from mysql.columns_priv where User='",Old_USER,"';");



PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

select "procs_priv table status : SUCCESS";

 else

 select "procs_priv privileges not available for this user. status : FAILED";

end if;


flush privileges;


end

$$

delimiter ;
