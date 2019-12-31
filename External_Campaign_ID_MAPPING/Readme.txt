1- backup Admin backend jar and the common.
2- replace the new jars and redeploy.
3- Run two below script to check the next proper campaign id.
	
	- select max(campaign_id) from ADM_CAMPAIGNS;
	- remove all IDs set manually or set back to a smaller unused campaign ID (ranges 1-1000); 
	- select ADM_CAMPAIGNS_SEQ.nextval from dual; (this query should return campaign_id greater than previous select statment)


4- Run attached sql script to create new table of mapping campaign ids.
5- backup Gateway backend jar and the common.
6- replace the new jars and redeploy.
7- insert in this table the mapping between NDP new generated campaign id and the id from the old system.
8- append dials to the campaign by gateway API by the old id.
