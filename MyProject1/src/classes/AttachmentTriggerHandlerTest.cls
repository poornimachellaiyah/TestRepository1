/*Dinesh-TPT-RecruitV2 changes-06/June/2015
 Test class created for the AttachementTriggerHandler.*/
 
@isTest
private class AttachmentTriggerHandlerTest{

    static testMethod void testAttachments()
    {
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'share1', email='AttachmentTestUser@testorg.com', 
            emailencodingkey='UTF-8', lastname='AttachmentTestUser', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='AttachmentTestUser@testorg.com');
        
        
            
        list<Country__c> lstCountry = new list<Country__c>();
        list<Job__c> lstJobs = new list<Job__c>();
            
        //prepare a dummy data for Country
        for(integer i=0; i<2;i++){
              Country__c country = new Country__c(Name = 'TestClassCountry'+i,Region__c = 'Europe',Country_People_Manager__c = u1.Id,Country_Director__c = u1.Id);
            lstCountry.add(country);
        }
        //insert countries
        insert lstCountry;
            
        List<RecordType> JobRecordTypes=new List<RecordType>();
        JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
            
        System.runAs(u1) 
        {            
            for(integer i=0; i<2;i++){
                if(i<1){
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
                    lstJobs.add(jb);
                }else{
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
                    lstJobs.add(jb);
                }
            } 
            insert lstJobs;        
 			test.startTest();
			List<Attachment> lstattach=new List<Attachment>();
            Attachment attach=new Attachment();     
            attach.Name='VSOJD';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=lstJobs[0].id;
            lstattach.add(attach);            
            
            Attachment attach1=new Attachment();     
            attach1.Name='TestFile';
            Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob1;
            attach1.parentId=lstJobs[1].id;
            lstattach.add(attach1);
            
            insert lstattach;           
            test.stopTest();
            
            Job__c job=[select id,help_JD_Attached__c,Job_Description_Attached__c from Job__c where id=:lstJobs[0].Id];
            System.assertEquals(True, job.help_JD_Attached__c);
            Job__c job1=[select id,help_JD_Attached__c,Job_Description_Attached__c from Job__c where id=:lstJobs[1].Id];
            System.assertEquals(False, job1.help_JD_Attached__c);
        }
    }
}