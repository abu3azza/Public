Tuesday 25th of Feb 2020
Deployment Details:
1- Multiple Fake senders enhancement.
2- Campaigns with 1-5 dials status failed while all SMSs sent (issue fix).
3- Request/Response logging.
4- Password removal in Resp/logging.
5- Logging enhancements (Mail sent by Support Team) will be marked in mail for clarity.

Deployment Steps:
1- Run the attached scripts "deployment.sql" and "CleanFinishedCampaigns.sql"
2- Run the attached script "MultipleFakeSender.sql"
3- CD to SMSEngine location.
4- Modify application.properties file to add the new properties in file "smpp_adapter_new_properties.txt"
5- Repeat the following steps for:
	a- NDPAdminWebService
	b- NDPCampaignGateway
	c- NDPCampaignHandler
	d- NDPOpenEndedCampaignHandler
	e- NDPFileUploadsHandler
	f- QuotaWebService
	g- NDPReportingEngine
	h- NDPSmsEngine
	Steps:
		1- Go to component lib folder
		2- Rename old jar to .bk<date>
		3- Rename ndp-common jar to .bk<date>
		4- Rename new jar to same name as old .jar
		5- Place new jar in lib folder
		6- Place the new common in lib folder
		7- Only for SMSEngine:
			-Rename sms-broker-core-1.0.jar to sms-broker-core-1.0.bk<date>
			-Place the new sms-broker-core-1.0 in lib folder
			-Repeat the above two steps for ndp-smpp-adapter.jar
6- Restart all system components