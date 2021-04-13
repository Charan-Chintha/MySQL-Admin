delimiter $$

drop procedure if exists sp_host_selected_user$$

create procedure sp_host_selected_user(in Old_HOST varchar(100),in New_HOST varchar(100),in user1 varchar(100))
begin

declare V_DBNAME varchar(50);
declare V_Val  varchar(1000);
declare V_in_Val varchar(1000);
declare V_cnt int;

select concat("Old host is : ",Old_HOST," New host is : ",New_HOST) as new; 

select "*****************Creation of users with new host***********************";

select count(1) into V_cnt from mysql.user where host=Old_host;

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='user';  
 select replace(V_in_Val,"Host,",concat('"',New_HOST,'",')) into V_Val;

 set @t1 =concat("insert into mysql.user(",V_in_Val,") select ",V_Val," from mysql.user where Host='",Old_HOST,"'"," and user in (","'",user1,"');");

SELECT @t1;

 PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

 else
 
  select "Host level privileges not available for this schema";

 end if;

select "*****************Preparing DB level privileges***********************";

select count(1) into V_cnt from mysql.db where host=Old_host;

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='db';  
 select replace(V_in_Val,"Host,",concat('"',New_HOST,'",')) into V_Val;

 set @t1 =concat("insert into mysql.db(",V_in_Val,") select ",V_Val," from mysql.db where Host='",Old_HOST,"'"," and user in (","'",user1,"');");

SELECT @t1;

PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

 else
 
  select "Database level privileges not available for this schema";

 end if;

select "***********************Preparing Table level privileges******************" ;

select count(1) into V_cnt from mysql.tables_priv where host=Old_host; 

 if V_cnt>0 then


 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='tables_priv';  
 select replace(V_in_Val,"Host,",concat('"',New_HOST,'",')) into V_Val;

 set @t1 =concat("insert into mysql.tables_priv(",V_in_Val,") select ",V_Val," from mysql.tables_priv where Host='",Old_HOST,"'"," and user in (","'",user1,"');");

SELECT @t1;

PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

 else

 select "Table level privileges not available for this schema";

 end if;

select "***********************Preparing Column level privileges******************" ;

select count(1) into V_cnt from mysql.columns_priv where host=Old_host; 

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='columns_priv';  
 select replace(V_in_Val,"Host,",concat('"',New_HOST,'",')) into V_Val;

 set @t1 =concat("insert into mysql.columns_priv(",V_in_Val,") select ",V_Val," from mysql.columns_priv where Host='",Old_HOST,"'"," and user in (","'",user1,"');");

SELECT @t1;

PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

 else

 select "Column level privileges not available for this schema";

end if;

select "***********************Preparing Procedure/Function level privileges******************" ;

select count(1) into V_cnt from mysql.procs_priv where host=Old_host; 

 if V_cnt>0 then

 select group_concat(column_name) into V_in_Val from information_Schema.columns where table_schema='mysql' and table_name='procs_priv';  
 select replace(V_in_Val,"Host,",concat('"',New_HOST,'",')) into V_Val;

 set @t1 =concat("insert into mysql.procs_priv(",V_in_Val,") select ",V_Val," from mysql.procs_priv where Host='",Old_HOST,"'"," and user in (","'",user1,"');");
SELECT @t1;

PREPARE stmt3 FROM @t1;

 EXECUTE stmt3;

 DEALLOCATE PREPARE stmt3;

 else

 select "Procedure/Function level privileges not available for this schema";

end if;

flush privileges;


end

$$

delimiter ;
