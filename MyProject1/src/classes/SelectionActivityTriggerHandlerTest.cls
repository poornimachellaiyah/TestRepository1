@isTest
private class SelectionActivityTriggerHandlerTest
{
    static testMethod void testUpdateContactdetails()
    {
    
         Id countryUser = [SELECT Id FROM User WHERE UserRoleId!='' AND isActive=true LIMIT 1].Id;
         
         Profile p1 = [select id from profile where name='System Administrator']; 
         User u1 = new User(alias = 'selection1', email='SelectionActivity_ContactUpdate@test.com', 
            emailencodingkey='UTF-8', lastname='Selection_ContactUpdate', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='SelectionActivity_ContactUpdate@test.com');
         
         Account acc=new Account(Name='Recruitment Partner - VSO Netherlands');
         insert acc;
          
         Country__c country=new Country__c(Name='TestCountry', Region__c='India', Country_People_Manager__c=countryUser, Country_Director__c=countryUser);  
         insert country;
         
         List<RecordType> JobRecordType=new List<RecordType>();
         JobRecordType=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Corporate_Job_Approved')];   
         
         Job__c job=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordType[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob',Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT',Country__c=country.id,Job_Status__c='Approved for Recruitment');
         insert job;

         List<Contact> lstcon=new List<Contact>();
         for(Integer i=0;i<3;i++)
         {
            Contact con=new Contact(Firstname='TestSelection_firstname'+i,lastname='TestSelection_lastname'+i,Knowledge_Exchange_Applicant__c=True);
            lstcon.add(con);
         }         
         insert lstcon;         
         
         List<Application__c> lstapp=new List<Application__c>();
         for(Integer a=0;a<3;a++)
         {
         	Application__c appln=new Application__c(Applicant__c=lstcon[a].id ,Send_Decline_Email__c=false, Job__c=job.Id , Submission_Date__c=system.today());
            lstapp.add(appln);
         }
         insert lstapp;         
         
         Selection_Tool__c selectionTool = new Selection_Tool__c(Name='SelectionTest',Type__c='Assessment',Subtype__c='Individual');
         insert selectionTool;
         
        
        //[ AND (Developername='Blended_Selection'OR Developername='Assessment_Day'OR Developername='Preliminary_Interview')];
         Map<String,Id> SelectionRecordType=new Map<String,Id> ();
            for(RecordType rt:[select id,developername,name from RecordType where SobjectType='Application_Selection_Tool__c']){
                SelectionRecordType.put(rt.developername,rt.id);
            }
         
        list<Application_Selection_Tool__c> lstSelAct=new List<Application_Selection_Tool__c>();
        for(Integer s=0;s<3;s++)
        {
            if(s==0){
        	Application_Selection_Tool__c selection=new Application_Selection_Tool__c (RecordTypeId=SelectionRecordType.get('Assessment_Day'),Contact__c=lstcon[s].id,Application__c=lstapp[s].Id,Selection_Tool__c=selectionTool.Id,
                                                                                       Due_Date_del__c=system.today()+10,Interview_Date__c=system.today()+5,Overall_Selection_Outcome__c='Failed selection',Outcome_Decision_Date__c=system.today(),
                                                                                       Rejection_Competency_1__c='Personal circumstances', Overall_Decision_Rationale__c='test',AD_Interview_Score_Adaptability__c='0',AD_Interview_Score_Change__c='1',
                                                                                       AD_Interview_Score_Knowledge__c='0',AD_Interview_Score_Relationships__c='0',AD_Interview_Score_Resilience__c='1',AD_Interview_Score_Respect__c='0',
                                                                                       Discussion_Exercise_Competency_1__c='Adaptability',Discussion_Exercise_Competency_2__c='Open-minded and respectful',Discussion_Exercise_Competency_3__c='Facilitating positive change',
                                                                                       Discussion_Exercise_Score_1__c='1',Discussion_Exercise_Score_2__c='1',Discussion_Exercise_Score_3__c='1',Overall_Score_Adaptability__c='1',Overall_Score_Change__c='1',
                                                                                       Overall_Score_Knowledge__c='1',Overall_Score_Relationships__c='1',Overall_Score_Resilience__c='1',Overall_Score_Respect__c='1',Practical_Exercise_Competency_1__c='Adaptability',
                                                                                       Practical_Exercise_Competency_2__c='Open-minded and respectful',Practical_Exercise_Competency_3__c='Facilitating positive change',Practical_Exercise_Score_1__c='3',
                                                                                       Practical_Exercise_Score_2__c='2',Practical_Exercise_Score_3__c='3');
                lstSelAct.add(selection);}
            if(s==1){
        	Application_Selection_Tool__c selection=new Application_Selection_Tool__c (RecordTypeId=SelectionRecordType.get('Blended_Selection'),Contact__c=lstcon[s].id,Application__c=lstapp[s].Id,Selection_Tool__c=selectionTool.Id,
                                                                                       Due_Date_del__c=system.today()+10,Interview_Date__c=system.today()+5,Overall_Selection_Outcome__c='Passed selection',Outcome_Decision_Date__c=system.today(),
                                                                                       Overall_Decision_Rationale__c='test',Overall_Score_Adaptability__c='3',Overall_Score_Change__c='3',Overall_Score_Knowledge__c='3',Overall_Score_Relationships__c='2',
                                                                                       Overall_Score_Resilience__c='3',Overall_Score_Respect__c='2',Panel_Score_Adaptability__c='2',Panel_Score_Change__c='2',Panel_Score_Knowledge__c='2',
                                                                                       Panel_Score_Relationships__c='3',Panel_Score_Resilience__c='2',Panel_Score_Respect__c='3',SJT_Score_Adaptability__c=75,SJT_Score_Change__c=90,SJT_Score_Knowledge__c=80,
                                                                                       SJT_Score_Relationships__c=75,SJT_Score_Resilience__c=86,SJT_Score_Respect__c=95);
                lstSelAct.add(selection);}
            if(s==2){
        	Application_Selection_Tool__c selection=new Application_Selection_Tool__c (RecordTypeId=SelectionRecordType.get('Preliminary_Interview'),Contact__c=lstcon[s].id,Application__c=lstapp[s].Id,Selection_Tool__c=selectionTool.Id,
                                                                                       Due_Date_del__c=system.today()+10,Interview_Date__c=system.today()+2,Interview_Score__c='0',Outcome_Decision_Date__c=system.today(),Primary_Rejection_Reason__c='Personal circumstances');
                lstSelAct.add(selection);}
        }
        insert lstSelAct; 
        
        Contact c=[Select id,Date_Last_Failed_Selection__c,Period_Until_Suitable_for_Reassessment__c from Contact where id=:lstcon[0].Id];
        System.assertEquals(System.today(),c.Date_Last_Failed_Selection__c);
        System.assertEquals('12 Months', c.Period_Until_Suitable_for_Reassessment__c);
        
        Contact c1=[Select id,Date_Last_Passed_Selection__c from Contact where id=:lstcon[1].Id];
        System.assertEquals(System.today(),c1.Date_Last_Passed_Selection__c);
        
        Contact c2=[Select id,Date_Last_Failed_Selection__c,Period_Until_Suitable_for_Reassessment__c from Contact where id=:lstcon[2].Id];
        System.assertEquals(System.today()+2,c2.Date_Last_Failed_Selection__c);
        System.assertEquals('6 Months', c2.Period_Until_Suitable_for_Reassessment__c);
    }
}