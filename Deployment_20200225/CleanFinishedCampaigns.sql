ALTER TABLE ADM_CAMPAIGNS Add LAST_STATUS_CHANGE DATE DEFAULT (sysdate);

create or replace PROCEDURE "CLEAN_FINISHED_CAMPAIGNS" (
   P_STATUS           OUT NUMBER,
   P_STATUS_MESSAGE   OUT VARCHAR2)
AS
-- THIS PROCEDURE UPDATES THE FINISHED CAMPAIGNS AND DROP ITS OTF PARTITION
   CURSOR EXPIRED_CAMPAIGNS
   IS
      SELECT CAMPAIGN_ID
        FROM ADM_CAMPAIGNS
       WHERE (END_DATE < SYSDATE AND STATUS = 4)
       OR ((STATUS IN (5,6,9,11,13)) and sysdate - LAST_STATUS_CHANGE > INTERVAL '15' MINUTE);

   V_STATUS              NUMBER;
   V_STATUS_MESSAGE      VARCHAR2 (32767);
   V_EXCEPTION_MESSAGE   VARCHAR2 (32767) := '';
BEGIN
   P_STATUS := -100;

   FOR rec IN EXPIRED_CAMPAIGNS
   LOOP
      BEGIN
         DROP_OTF_PARTITION (REC.CAMPAIGN_ID, V_STATUS, V_STATUS_MESSAGE);
      EXCEPTION
         WHEN OTHERS
         THEN
            V_EXCEPTION_MESSAGE :=
               V_EXCEPTION_MESSAGE || ' (DROP_OTF_PARTITION ERR:-' || SQLERRM || ')';
      END;
      
      BEGIN
         DROP_SMS_QUEUE ('QT_' || REC.CAMPAIGN_ID);
         delete from H_SMS_CONCAT_S where CAMPAIGN_ID = REC.CAMPAIGN_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            V_EXCEPTION_MESSAGE :=
               V_EXCEPTION_MESSAGE || ' (DROP_SMS_QUEUE ERR:-' || SQLERRM || ')';
      END;

      IF    P_STATUS = 1
         OR (V_STATUS = 0 AND P_STATUS = -100)
         OR (V_STATUS = -100 AND P_STATUS = 0)
      THEN
         P_STATUS := 1;
      ELSE
         P_STATUS := V_STATUS;
      END IF;
   END LOOP;

   IF (P_STATUS = -100)
   THEN
      P_STATUS_MESSAGE := 'Unhandled Exception, No Campaigns Handled';
   ELSIF (P_STATUS = 1)
   THEN
      P_STATUS_MESSAGE := 'Some campaigns failed to be handled';
   ELSE
      P_STATUS_MESSAGE := 'Success';
   END IF;

   P_STATUS_MESSAGE := P_STATUS_MESSAGE || ' ' || V_EXCEPTION_MESSAGE;
   COMMIT;
END;
