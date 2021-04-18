These procedures are help us to copy the bulk grants in Database.

SP_DB_grant Description: 

This procedure will help us to copy the all exisitng grants of existing schema for newly created schema in same server. 

call SP_DB_grant('source schema','Target schema');
source schema : Existing schema in the same server
Target schema : newly created schema in same server
