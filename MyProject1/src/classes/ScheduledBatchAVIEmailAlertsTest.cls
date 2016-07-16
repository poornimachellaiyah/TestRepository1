@isTest
private class ScheduledBatchAVIEmailAlertsTest{

public static String CRON_EXP = '0 0 0 3 9 ? 2022';

static testMethod void testAVIEmailAlert() 
{
 
   String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new ScheduledBatchAVIEmailAlerts());
   CronTrigger ct = [ SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId ];
   System.assertEquals(CRON_EXP, ct.CronExpression);
   System.assertEquals(0, ct.TimesTriggered);
   System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime) );

   Profile p1 = [select id from profile where name='System Administrator'];  
   User u1 = new User(alias = 'share1', email='testAvi1@testorg.com', 
   emailencodingkey='UTF-8', lastname='testavi', languagelocalekey='en_US', 
   localesidkey='en_US', profileid = p1.Id, 
   timezonesidkey='America/Los_Angeles', username='testavi1@testorg.com');
            
   list<Country__c> lstCountry = new list<Country__c>();
   list<Job__c> lstJobs = new list<Job__c>();
   list<Application__c> lstApps = new list<Application__c>();
   
   for(integer i=0; i<5;i++)
   {
      Country__c cntry = TestDataClass.getCountry('TestClassCountry'+i);
      lstCountry.add(cntry);
   }
   
   insert lstCountry;
            
   List<RecordType> JobRecordTypes=new List<RecordType>();
   JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
   for(integer i=0; i<5;i++)
   {
     if(i<3)
     {
        Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
        lstJobs.add(jb);
     }
     else
     {
        Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
        lstJobs.add(jb);
     }
   }       
  
   insert lstJobs;
            
  
   Contact con=new Contact(Firstname='TestSite1',lastname='user1',email='developmenttpt@vsoint.org',Available_From__c=system.today(),Available_To__c=system.today()+360,
                           Preferred_Name__c='Test AVI',Primary_Skill__c='Test Skill',npe01__PreferredPhone__c='Mobile',MobilePhone='234234',HomePhone='123123',Gender__c='Male',Skype_User_Name__c='test');
   insert con;
   
   
   
   Account acc=new Account(Name='Recruitment Partner-AVI');
   insert acc;
   
   Application__c app=new Application__c(Applicant__c=con.id ,Is_Email_Sent_to_AVI__c=false,Assigned_Recruitment_Partner__c=acc.id,Send_Decline_Email__c=false, Job__c=lstJobs[0].Id , Submission_Date__c=system.today(),
                                         Current_Education_Level__c='Secondary',  Evidence_To_Support_Job_Criteria__c='test',
                                         Is_AVI_Application_Form__c=true);
   insert app; 
   
   
   Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
   
   Attachment attach=new Attachment(Name='Unit Test Attachment',body=bodyBlob,parentId=app.id);
   insert attach;
  
   VSO_Settings__c cs = new VSO_Settings__c (AVI_Admin_Email_id__c='developmenttpt@vsoint.org',Site_URL__c='test.salesforce.com');
   insert cs;
 
   SendApplicantDetailsToAVI ea=new SendApplicantDetailsToAVI ();
   Database.executeBatch(ea,10);  
}

}