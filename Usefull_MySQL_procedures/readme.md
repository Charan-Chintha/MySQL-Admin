These procedures are help us to copy the bulk grants in Database.

<h3>SP_DB_grant Description: </h3>

This procedure will help us to copy the all exisitng grants of existing schema for newly created schema in same server. 

call SP_DB_grant('source schema','Target schema');</br>
source schema : Existing schema in the same server</br>
Target schema : newly created schema in same server</br>
