DELIMITER $$
DROP PROCEDURE IF EXISTS update_multiple_example_proc$$
CREATE PROCEDURE update_multiple_example_proc()
BEGIN
DECLARE x  bigint;

SET x = 1;
max_value= SELECT MAX(document_id) FROM cms_doc_header;
WHILE x  <= max_value DO
update charan.table set abc='efh' where uhg='worl' between x and x+20000;
SET  x = x + 20000;
COMMIT ;
update tmp.job_result set id=x;
commit;
END WHILE;

END$$
DELIMITER ;



