@isTest
private class ContinuingAssessmentTriggerTest 
{

    static testMethod void testupdateApplicationRecordPositive() 
    {           
        
        Id countryUser = [SELECT Id FROM User WHERE UserRoleId!='' AND isActive=true LIMIT 1].Id;      
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'ohare2', email='conti_hiringManagerShare2@testorg.com', 
        emailencodingkey='UTF-8', lastname='conti_hiringManagerShare2', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1.Id, 
        timezonesidkey='America/Los_Angeles', username='conti_hiringManagerShare2@testorg.com');  
        
                 
        list<Country__c> lstCountry = new list<Country__c>();
        list<Job__c> lstJobs = new list<Job__c>();
        list<Application__c> lstApps = new list<Application__c>(); 
        list<Continuing_Assessment__c>  lstconti = new list<Continuing_Assessment__c>(); 
        list<Contact >  lstcon= new list<Contact>();
                          
        for(integer i=0;i<2;i++){
        Country__c country=new Country__c(Name='TestClassCountry', Region__c='Europe', Country_People_Manager__c=countryUser, Country_Director__c=countryUser);
        lstCountry.add(country);
        }
        insert lstCountry;
        
        List<RecordType> JobRecordTypes=new List<RecordType>();
        JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
                       
            
        System.runAs(u1) 
        {
            
            Account acc = new Account(Name='Test');
                insert acc;
            for(integer i=0;i<2;i++)
            {
                Contact con = new Contact(Firstname='Test',lastname='user1',email='test@testorg.com',Related_Employee__c=u1.id,Primary_Type__c='Applicant');
                lstcon.add(con);
            }    
            insert lstcon;
      
            for(integer i=0;i<2;i++)
            {
                Job__c job=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob',Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,Job_Title__c='JT',Country__c=lstCountry[0].id,Job_Status__c='Approved for Recruitment');
                lstJobs.add(job);
            }                
            insert lstJobs;
             
            for(integer i=0;i<2;i++)
            {
                Application__c app = new Application__c(Applicant__c=lstcon[0].id ,Job__c=lstJobs[0].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',Consent_Date__c=system.today(),Declaration_Date__c=system.today());
                lstApps.add(app);
            }   
                
            insert lstApps; 
            
            for(integer i=0;i<2;i++)
            {                                  
                Continuing_Assessment__c conti= new Continuing_Assessment__c ();                        
                conti.Contact__c=lstcon[0].id;
                conti.Application__c=lstApps[0].id;
                conti.Stage_Related_To__c='Pre-Departure: Application / Selection';
                conti.Concern_Identified_By_Name_Role__c='Test';
                conti.Organisation__c=acc.id;
                conti.Date_Concern_Logged__c=system.today();
                conti.Primary_Concern_Category__c='Commitment to VSO';
                conti.SR_Follow_Up_Outcome__c='Volunteer Status Withdrawn';  
                conti.SR_Follow_Up_Outcome_Date__c=system.today(); 
                conti.SR_Follow_Up_Outcome_Summary__c='Test'; 
                lstconti.add(conti);  
             }      
             insert lstconti;         
                                                      
         Test.startTest();           
         ContinuingAssessmentTriggerHandler.ClearRunOnce();
             lstApps[0].Reason_For_Candidate_Withdrawal__c ='VSO Factor';
             lstApps[0].Further_Details_of_Withdrawal__c='Selection Review';  
             lstApps[0].Status__c='Offer Withdrawn by VSO';                  
             lstApps[0].Status__c='Withdrawn (Candidate Requested)';
             lstApps[0].Date_Of_Candidate_Withdrawal__c=system.today();         
        update lstApps;
        Test.StopTest();
      }
       
    }

    static testMethod void testupdateApplicationRecordnegative() 
    {           
        System.debug('My test class');
        Id countryUser = [SELECT Id FROM User WHERE UserRoleId!='' AND isActive=true LIMIT 1].Id;      
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'ohare2', email='conti_hiringManagerShare2@testorg.com', 
        emailencodingkey='UTF-8', lastname='conti_hiringManagerShare2', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1.Id, 
        timezonesidkey='America/Los_Angeles', username='conti_hiringManagerShare2@testorg.com');  
        
                 
        list<Country__c> lstCountry = new list<Country__c>();
        list<Job__c> lstJobs = new list<Job__c>();
        list<Application__c> lstApps = new list<Application__c>(); 
        list<Continuing_Assessment__c>  lstconti = new list<Continuing_Assessment__c>(); 
       
                          
        for(integer i=0;i<1;i++){
        Country__c country=new Country__c(Name='TestClassCountry', Region__c='Europe', Country_People_Manager__c=countryUser, Country_Director__c=countryUser);
        lstCountry.add(country);
        }
        insert lstCountry;
        
        List<RecordType> JobRecordTypes=new List<RecordType>();
        JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
                       
            
        System.runAs(u1) 
        {
            
            Account acc = new Account(Name='Test');
                insert acc;
            
                Contact con = new Contact(Firstname='Test',lastname='user1',email='test@testorg.com',Related_Employee__c=u1.id,Primary_Type__c='Applicant');
               insert con;
            
      
            for(integer i=0;i<1;i++)
            {
                Job__c job=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob',Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,Job_Title__c='JT',Country__c=lstCountry[0].id,Job_Status__c='Approved for Recruitment');
                lstJobs.add(job);
            }                
            insert lstJobs;
             
            for(integer i=0;i<1;i++)
            {
                Application__c app = new Application__c(Applicant__c=con.id ,Job__c=lstJobs[0].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',Consent_Date__c=system.today(),Declaration_Date__c=system.today());
                lstApps.add(app);
            }   
                
            insert lstApps; 
            
            for(integer i=0;i<1;i++)
            {                                  
                Continuing_Assessment__c conti= new Continuing_Assessment__c ();                        
                conti.Contact__c=con.id;
                conti.Application__c=lstApps[0].id;
                conti.Stage_Related_To__c='Pre-Departure: Application / Selection';
                conti.Concern_Identified_By_Name_Role__c='Test';
                conti.Organisation__c=acc.id;
                conti.Date_Concern_Logged__c=system.today();
                conti.Primary_Concern_Category__c='Commitment to VSO';
                conti.Follow_Up_Outcome_Date__c=System.today();
                conti.Follow_Up_Outcome_Summary__c='Test';
                conti.Follow_Up_Outcome__c='Withdrawn (Candidate Requested)';
                conti.Discussion_Outcome__c='N/A - To Be Discussed at Selection Interview'; 
                conti.Discussion_Date__c=System.today(); 
                conti.Discussion_Summary__c='Test';
                lstconti.add(conti);        
             }      
             insert lstconti;  
                 
                                                      
         Test.startTest();           
         ContinuingAssessmentTriggerHandler.ClearRunOnce();
             lstApps[0].Reason_For_Candidate_Withdrawal__c ='VSO Factor';
             lstApps[0].Further_Details_of_Withdrawal__c='Selection Review';                              
             lstApps[0].Status__c='Withdrawn (Candidate Requested)';            
        
        try{
        update lstApps;
         }
         catch (DMLException e)
         {
             system.debug('Application Record Update Failed:'+e.getmessage());
          }
        
        Test.StopTest();
       
      }
       
    }
    
   
   static testMethod void testupdateContactRecord() 
    {           
        
        Id countryUser = [SELECT Id FROM User WHERE UserRoleId!='' AND isActive=true LIMIT 1].Id;      
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'ohare2', email='conti_hiringManagerShare2@testorg.com', 
        emailencodingkey='UTF-8', lastname='conti_hiringManagerShare2', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1.Id, 
        timezonesidkey='America/Los_Angeles', username='conti_hiringManagerShare2@testorg.com');   
        
        
        list<Country__c> lstCountry = new list<Country__c>();
        list<Job__c> lstJobs = new list<Job__c>();
        list<Application__c> lstApps = new list<Application__c>();        
        list<Continuing_Assessment__c>  lstconti = new list<Continuing_Assessment__c>();
                          
        for(integer i=0;i<1;i++)
        {
            Country__c country=new Country__c(Name='TestClassCountry', Region__c='Europe', Country_People_Manager__c=countryUser, Country_Director__c=countryUser);
            lstCountry.add(country);
        }
        insert lstCountry;
        
        List<RecordType> JobRecordTypes=new List<RecordType>();
        JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
                       
            
        System.runAs(u1) 
        {
            
            Account acc = new Account(Name='Test');
                insert acc;
            
            Contact con = new Contact(Firstname='Test',lastname='user1',email='test@testorg.com',Related_Employee__c=u1.id,Primary_Type__c='Applicant');
                insert con;
      
            for(integer i=0;i<1;i++)
            {
                Job__c job=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob',Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,Job_Title__c='JT',Country__c=lstCountry[0].id,Job_Status__c='Approved for Recruitment');
                lstJobs.add(job);
            }                
            insert lstJobs;
             
            for(integer i=0;i<1;i++)
            {
                Application__c app = new Application__c(Applicant__c=con.id ,Job__c=lstJobs[0].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',Consent_Date__c=system.today(),Declaration_Date__c=system.today());
                lstApps.add(app);
            }   
                
            insert lstApps; 
         
               
            for(integer i=0;i<1;i++)
            {    
            Continuing_Assessment__c conti= new Continuing_Assessment__c ();                        
            conti.Contact__c=con.id;
            conti.Application__c=lstApps[0].id;
            conti.Stage_Related_To__c='Pre-Departure: Application / Selection';
            conti.Concern_Identified_By_Name_Role__c='Test';
            conti.Organisation__c=acc.id;
            conti.Date_Concern_Logged__c=system.today();
            conti.Primary_Concern_Category__c='Commitment to VSO';
            conti.Status_Review_Date__c=system.today();
            conti.Status_Review_Outcome__c='Withdrawn (Candidate Requested)';
            conti.Status_Review_Summary__c='Test';
            lstconti.add(conti);  
            }      
             insert lstconti;    
                
            Test.startTest();
            ContinuingAssessmentTriggerHandler.ClearRunOnce();
            con.Unsuitable_to_Volunteer__c =TRUE;
            con.Reason_Unsuitable_to_Volunteer__c='Selection Review';  
            con.Period_Until_Suitable_for_Reassessment__c='Not Suitable';        
            update con;
            Test.StopTest();
      }
       
   }
   
	static testMethod void testupdateOfferRecord1() 
    {           
       	TestRecords test1=setupRecordsForTest();
       	Application__c testapp1=test1.testAppList[2];
       	Contact testcon1=test1.testContactList[2];
       	Account testacc1=test1.testAccountList[1];
       	OnboardingCheck__c testonb1=test1.testOnboardingList[2];
        
        Test.startTest();
        List<Continuing_Assessment__c> testCAList=new List<Continuing_Assessment__c>();
        testCAList.add(new Continuing_Assessment__c(Contact__c=testcon1.id,Application__c=testapp1.id,OnBoardingCheck__c=testonb1.Id,
         	Stage_Related_To__c='Pre-Departure: Onboarding / Training',Concern_Identified_By_Name_Role__c='Test',Organisation__c=testacc1.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',SR_Follow_Up_Outcome__c='Withdrawn (Candidate Requested)',
            SR_Follow_Up_Outcome_Date__c=system.today(),SR_Follow_Up_Outcome_Summary__c='Test'));
        insert testCAList;
        Test.stopTest();
        
        Offer__c ofr1=[Select id,Offer_Status__c,application__c from Offer__c where application__c=:testCAList[0].Application__c];
        System.assertEquals('Withdrawn (Candidate Requested)',ofr1.Offer_Status__c);
    }
    
    static testMethod void testupdateOfferRecord2() 
    {           
       	TestRecords test2=setupRecordsForTest();
       	Application__c testapp2=test2.testAppList[2];
       	Contact testcon2=test2.testContactList[2];
       	Account testacc2=test2.testAccountList[1];
       	OnboardingCheck__c testonb2=test2.testOnboardingList[2];
        
        Test.startTest();
        List<Continuing_Assessment__c> testCAList=new List<Continuing_Assessment__c>();
        testCAList.add(new Continuing_Assessment__c(Contact__c=testcon2.id,Application__c=testapp2.id,OnBoardingCheck__c=testonb2.Id,
         	Stage_Related_To__c='Pre-Departure: Onboarding / Training',Concern_Identified_By_Name_Role__c='Test',Organisation__c=testacc2.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',SR_Follow_Up_Outcome__c='Volunteer Status Withdrawn',
            SR_Follow_Up_Outcome_Date__c=system.today(),SR_Follow_Up_Outcome_Summary__c='Test'));
        insert testCAList;
        Test.stopTest();
        
        Offer__c ofr2=[Select id,Offer_Status__c,application__c from Offer__c where application__c=:testCAList[0].Application__c];
        System.assertEquals('Offer Withdrawn By VSO',ofr2.Offer_Status__c);
    }
         
  
  	static testMethod void testupdateRelatedOnboarding1() 
    {           
        TestRecords t1=setupRecordsForTest();
        OnboardingCheck__c onb1=t1.testOnboardingList[0];
        Application__c app1=t1.testAppList[0];
        Contact con1=t1.testContactList[0];
        Account acc1=t1.testAccountList[0];

        Test.startTest();       
        List<Continuing_Assessment__c> caList=new List<Continuing_Assessment__c>();
        caList.add(new Continuing_Assessment__c(Contact__c=con1.id,Application__c=app1.id,OnBoardingCheck__c=onb1.Id,
         	Stage_Related_To__c='Pre-Departure: Onboarding / Training',Concern_Identified_By_Name_Role__c='Test',Organisation__c=acc1.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',SR_Follow_Up_Outcome__c='Withdrawn (Candidate Requested)',
            SR_Follow_Up_Outcome_Date__c=system.today(),SR_Follow_Up_Outcome_Summary__c='Test'));
        insert caList;
        Test.StopTest();
        
        OnboardingCheck__c onboard=[select id,Onboarding_Status__c,Continuing_Assessment_Status__c from OnboardingCheck__c where id=:caList[0].OnBoardingCheck__c];
        System.assertequals('Withdrawn (Candidate Requested)',onboard.Onboarding_Status__c);
        System.assertequals('Volunteer Status Withdrawn',onboard.Continuing_Assessment_Status__c);
    }
    
    static testMethod void testupdateRelatedOnboarding2() 
    {           
        TestRecords t5=setupRecordsForTest();
        OnboardingCheck__c onb5=t5.testOnboardingList[0];
        Application__c app5=t5.testAppList[0];
        Contact con5=t5.testContactList[0];
        Account acc5=t5.testAccountList[0];

        Test.startTest();       
        List<Continuing_Assessment__c> caList=new List<Continuing_Assessment__c>();
        caList.add(new Continuing_Assessment__c(Contact__c=con5.id,Application__c=app5.id,OnBoardingCheck__c=onb5.Id,
         	Stage_Related_To__c='Pre-Departure: Onboarding / Training',Concern_Identified_By_Name_Role__c='Test',Organisation__c=acc5.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',SR_Follow_Up_Outcome__c='Volunteer Status Withdrawn',
            SR_Follow_Up_Outcome_Date__c=system.today(),SR_Follow_Up_Outcome_Summary__c='Test'));
        insert caList;
        Test.StopTest();
        
        OnboardingCheck__c onboard1=[select id,Onboarding_Status__c,Continuing_Assessment_Status__c,Reason_Not_Cleared_to_Start__c from OnboardingCheck__c where id=:caList[0].OnBoardingCheck__c];
        System.assertequals('Not Cleared to Start',onboard1.Onboarding_Status__c);
        System.assertequals('Volunteer Status Withdrawn',onboard1.Continuing_Assessment_Status__c);
        System.assertEquals('Continuing Assessment',onboard1.Reason_Not_Cleared_to_Start__c);
    }
    
    static testMethod void testupdateRelatedOnboarding3() 
    {           
        TestRecords t6=setupRecordsForTest();
        OnboardingCheck__c onb6=t6.testOnboardingList[0];
        Application__c app6=t6.testAppList[0];
        Contact con6=t6.testContactList[0];
        Account acc6=t6.testAccountList[0];

        Test.startTest();       
        List<Continuing_Assessment__c> caList=new List<Continuing_Assessment__c>();
        caList.add(new Continuing_Assessment__c(Contact__c=con6.id,Application__c=app6.id,OnBoardingCheck__c=onb6.Id,
         	Stage_Related_To__c='Pre-Departure: Onboarding / Training',Concern_Identified_By_Name_Role__c='Test',Organisation__c=acc6.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',Discussion_Outcome__c='Move to Status Review',  
            Discussion_Date__c=system.today(),Discussion_Summary__c='Test'));
        insert caList;
        Test.StopTest();
        
        OnboardingCheck__c onboard2=[select id,Onboarding_Status__c,Continuing_Assessment_Status__c,Reason_Not_Cleared_to_Start__c from OnboardingCheck__c where id=:caList[0].OnBoardingCheck__c];
        System.assertequals('Under Status Review',onboard2.Continuing_Assessment_Status__c);
   
    }
   

   
  static testMethod void testupdateRelatedEmploymentRecord1() 
   {           
       TestRecords t2=setupRecordsForTest();
       OnBoardingCheck__c onb2=t2.testOnboardingList[1];
       Application__c app2=t2.testAppList[1];
       Contact con2=t2.testContactList[1];
       Account acc2=t2.testAccountList[1];
       fHCM2__Department__c dept=t2.testDepartment;
      
       List<fHCM2__Employment__c> emp=[Select id from fHCM2__Employment__c where On_Boarding_Record__c=:onb2.Id];
       system.assertEquals(1, emp.size(), 'Employment record should be created' );
           
       Test.startTest();
       List<Continuing_Assessment__c> ca1List=new List<Continuing_Assessment__c>();
       ca1List.add(new Continuing_Assessment__c(Contact__c=con2.id,Application__c=app2.id,OnBoardingCheck__c=onb2.id,Employment__c=emp[0].id,
            Stage_Related_To__c='Pre-Departure: After Cleared To Start',Concern_Identified_By_Name_Role__c='Test',Organisation__c=acc2.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',Discussion_Outcome__c='Move to Status Review',  
            Discussion_Date__c=system.today(),Discussion_Summary__c='Test'));
       insert ca1List; 
       
       Test.stopTest();
       
       fHCM2__Employment__c testemp=[Select id,Continuous_Assessment_Status__c from fHCM2__Employment__c where id=:ca1List[0].Employment__c];
       OnBoardingCheck__c testonb=[select id,Continuing_Assessment_Status__c from OnBoardingCheck__c where id=:ca1List[0].OnBoardingCheck__c];
       system.assertEquals('Under Emergency Review', testonb.Continuing_Assessment_Status__c);
       system.assertEquals('Under Status Review (Pre-Departure)', testemp.Continuous_Assessment_Status__c);       
   }
    
   static testMethod void testupdateRelatedEmploymentRecord2() 
   {           
       TestRecords t3=setupRecordsForTest();
       OnBoardingCheck__c onb3=t3.testOnboardingList[1];
       Application__c app3=t3.testAppList[1];
       Contact con3=t3.testContactList[1];
       Account acc3=t3.testAccountList[1];
       fHCM2__Department__c dept=t3.testDepartment;
      
       List<fHCM2__Employment__c> emp=[Select id from fHCM2__Employment__c where On_Boarding_Record__c=:onb3.Id];
       system.assertEquals(1, emp.size(), 'Employment record should be created' );
           
       Test.startTest();
       List<Continuing_Assessment__c> ca2List=new List<Continuing_Assessment__c>();
       ca2List.add(new Continuing_Assessment__c(Contact__c=con3.id,Application__c=app3.id,OnBoardingCheck__c=onb3.id,Employment__c=emp[0].id,
            Stage_Related_To__c='Pre-Departure: After Cleared To Start',Concern_Identified_By_Name_Role__c='Test',Organisation__c=acc3.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',Discussion_Outcome__c='Withdrawn (Candidate Requested)',  
            Discussion_Date__c=system.today(),Discussion_Summary__c='Test'));
       insert ca2List;    
       Test.stopTest(); 
       
       fHCM2__Employment__c testemp1=[Select id,Continuous_Assessment_Status__c from fHCM2__Employment__c where id=:ca2List[0].Employment__c];
       OnBoardingCheck__c testonb1=[select id,Continuing_Assessment_Status__c,Onboarding_Status__c from OnBoardingCheck__c where id=:ca2List[0].OnBoardingCheck__c];
       system.assertEquals('Withdrawn (Candidate Requested)', testonb1.Onboarding_Status__c);
       system.assertEquals('Volunteer Status Withdrawn', testonb1.Continuing_Assessment_Status__c);
       system.assertEquals('Volunteer Status Withdrawn (Pre-Departure)', testemp1.Continuous_Assessment_Status__c);     
       
   }
    
   static testMethod void testupdateRelatedEmploymentRecord3() 
   {           
       TestRecords t4=setupRecordsForTest();
       OnBoardingCheck__c onb4=t4.testOnboardingList[1];
       Application__c app4=t4.testAppList[1];
       Contact con4=t4.testContactList[1];
       Account acc4=t4.testAccountList[1];
       fHCM2__Department__c dept=t4.testDepartment;
      
       List<fHCM2__Employment__c> emp=[Select id from fHCM2__Employment__c where On_Boarding_Record__c=:onb4.Id];
       system.assertEquals(1, emp.size(), 'Employment record should be created' );
           
       Test.startTest();
       List<Continuing_Assessment__c> ca3List=new List<Continuing_Assessment__c>();
       ca3List.add(new Continuing_Assessment__c(Contact__c=con4.id,Application__c=app4.id,OnBoardingCheck__c=onb4.id,Employment__c=emp[0].id,
            Stage_Related_To__c='Pre-Departure: After Cleared To Start',Concern_Identified_By_Name_Role__c='Test',Organisation__c=acc4.id,
            Date_Concern_Logged__c=system.today(),Primary_Concern_Category__c='Commitment to VSO',Status_Review_Outcome__c='Volunteer Status Withdrawn',  
            Status_Review_Date__c=system.today(),Status_Review_Summary__c='Test'));
       insert ca3List;    
       Test.stopTest(); 
       
       fHCM2__Employment__c testemp2=[Select id,Continuous_Assessment_Status__c from fHCM2__Employment__c where id=:ca3List[0].Employment__c];
       OnBoardingCheck__c testonb2=[select id,Continuing_Assessment_Status__c,Onboarding_Status__c from OnBoardingCheck__c where id=:ca3List[0].OnBoardingCheck__c];
       system.assertEquals('Volunteer Status Withdrawn (After Cleared To Start)', testonb2.Onboarding_Status__c);
       system.assertEquals('Volunteer Status Withdrawn', testonb2.Continuing_Assessment_Status__c);
       system.assertEquals('Volunteer Status Withdrawn (Pre-Departure)', testemp2.Continuous_Assessment_Status__c);       
   }
  
  
  
	static TestRecords setupRecordsForTest()
	{
        Profile p1 = [select id from profile where name='SP_People Group Manager_FSM'];  
        // need a user to set up the data
        User u1 = new User(alias = 'TestCA', email='TestUser_ContinuingAssessment@testorg.com', 
                emailencodingkey='UTF-8', lastname='TestUser', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p1.Id, 
                timezonesidkey='America/Los_Angeles', username='TestUser_ContinuingAssessment@testorg.com');
    
        // need a people manager for country
        Id countryUser = [SELECT Id FROM User WHERE UserRoleId!='' AND isActive=true LIMIT 1].Id;      
            
        Country__c country=new Country__c(Name='TestClassCountry', Region__c='Europe', Country_People_Manager__c=countryUser, Country_Director__c=countryUser);
        insert country;
            
        List<RecordType> jobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
        List<RecordType> offerRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND (Developername='Employee_Offer'OR Developername='Volunteer_Offer')]; 
        List<RecordType> onboardingRecordTypes=[select id,developername,name from RecordType where SobjectType='OnBoardingCheck__c' AND (Developername='Employee_Consultant' OR Developername='Volunteer')];    
        
        fHCM2__Policy__c policy = new fHCM2__Policy__c(name='TestPolicy', fHCM2__Hours_Per_Week__c = 30);
        insert policy;
        
        fHCM2__Department__c dept=new fHCM2__Department__c(name='TestDepartment', fHCM2__Policy__c = policy.Id);
        insert dept;     
        
        TestRecords ret = new TestRecords();   
        ret.testUser = u1;
        ret.testCountry = country;
        ret.testDepartment = dept;
        ret.jobRecordType = jobRecordTypes[0];
        ret.offerRecordType1 = offerRecordTypes[0];
        ret.offerRecordType2 = offerRecordTypes[1];
		ret.onboardingRecordType1= onboardingRecordTypes[0]; 
        ret.onboardingRecordType2= onboardingRecordTypes[1];
            
        System.runAs(u1) 
        {
            AddTestRecords(ret);
        }
        return ret;
    }
    
    private static void AddTestRecords(TestRecords testData)
    {
        
        List<Account> accountList = new List<Account>();
        accountList.add(new Account(Name='testAccount1'));
        accountList.add(new Account(Name='testAccount2'));
        insert accountList;
            
        //todo: different users related to contacts?    
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(Firstname='testContact1',lastname='user1',email='test1@testorg.com',Related_Employee__c=testData.testUser.id,Primary_Type__c='Applicant'));
        contactList.add(new Contact(Firstname='testContact2',lastname='user2',email='test2@testorg.com',Related_Employee__c=testData.testUser.id,Primary_Type__c='Applicant'));
        contactList.add(new Contact(Firstname='testContact3',lastname='user3',email='test3@testorg.com',Related_Employee__c=testData.testUser.id,Primary_Type__c='Applicant'));
        insert contactList;
             
        List<Job__c> jobList = new List<Job__c>();     
        jobList.add(new Job__c(Hiring_Manager__c=testData.testUser.id,RecordTypeid=testData.jobRecordType.id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='Testjob1',Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,
            Job_Title__c='JT1',Country__c=testData.testCountry.id,Job_Status__c='Approved for Recruitment'));
        jobList.add(new Job__c(Hiring_Manager__c=testData.testUser.id,RecordTypeid=testData.jobRecordType.id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='Testjob2',Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,
            Job_Title__c='JT2',Country__c=testData.testCountry.id,Job_Status__c='Approved for Recruitment'));
        jobList.add(new Job__c(Hiring_Manager__c=testData.testUser.id,RecordTypeid=testData.jobRecordType.id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='Testjob3',Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,
            Job_Title__c='JT3',Country__c=testData.testCountry.id,Job_Status__c='Approved for Recruitment'));
        insert jobList;
             
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Applicant__c=contactList[0].id ,Job__c=jobList[0].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',
            Consent_Date__c=system.today(),Declaration_Date__c=system.today()));
        appList.add(new Application__c(Applicant__c=contactList[1].id ,Job__c=jobList[1].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',
            Consent_Date__c=system.today(),Declaration_Date__c=system.today()));
        appList.add(new Application__c(Applicant__c=contactList[2].id ,Job__c=jobList[2].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',
            Consent_Date__c=system.today(),Declaration_Date__c=system.today()));
        insert appList; 
        
        List<Offer__c> offerList = new List<Offer__c>();
        offerList.add(new Offer__c(Applicant__c=contactList[0].id ,Application__c=appList[0].id,Status__c='Sent',VSO_Offer_Contact_Person__c=testData.testUser.id,RecordTypeid=testData.offerRecordType1.id,
            Payroll_Office_processing_location__c=testData.testCountry.id, Offer_Status__c='Verbal Offer Accepted'));             
        offerList.add(new Offer__c(Applicant__c=contactList[1].id ,Application__c=appList[1].id,Status__c='Sent',VSO_Offer_Contact_Person__c=testData.testUser.id,RecordTypeid=testData.offerRecordType1.id,
            Payroll_Office_processing_location__c=testData.testCountry.id, Offer_Status__c='Verbal Offer Accepted'));
        offerList.add(new Offer__c(Applicant__c=contactList[2].id ,Application__c=appList[2].id,Status__c='Sent',VSO_Offer_Contact_Person__c=testData.testUser.id,RecordTypeid=testData.offerRecordType2.id,
            Offer_Status__c='Verbal Offer Accepted',Proposed_Start_Date__c=system.today()-10,Proposed_End_Date__c=system.today()+10));
        insert offerList;
       
        offerList[0].Offer_Status__c= 'Conditional Offer Accepted';
        offerList[1].Offer_Status__c= 'Conditional Offer Accepted';
        offerList[2].Offer_Status__c= 'Conditional Offer Accepted';
        update offerList;                                   
          
        List<OnBoardingCheck__c> obcList = new List<OnBoardingCheck__c>();
        obcList.add(new OnBoardingCheck__c(RecordTypeId=testData.onboardingRecordType1.Id,Individual_Responsible_for_Completion__c=contactList[0].id,Make_Visible_To_Starter__c=true,Contact__c=contactList[0].id,Offer__c=offerList[0].id,
            Onboarding_Status__c='Onboarding In Progress',Application__c=appList[0].id,Recruitment_Partner__c=accountList[0].id,Relationship_Manager__c=testData.testUser.id));
        obcList.add(new OnBoardingCheck__c(RecordTypeId=testData.onboardingRecordType1.Id,Individual_Responsible_for_Completion__c=contactList[0].id,Make_Visible_To_Starter__c=true,Contact__c=contactList[1].id,Offer__c=offerList[1].id,
           Application__c=appList[1].id,Recruitment_Partner__c=accountList[1].id,Relationship_Manager__c=testData.testUser.id,Onboarding_Status__c = 'Cleared to Start',Cleared_to_Start_Date__c=system.today(),
           Confirmed_Start_of_Service_Date__c=system.today()+5,Criminal_Background_Clearance_Status__c = 'Cleared',Criminal_Background_Clearance_Date__c =system.today(),
           Criminal_Background_Reviewer__c = UserInfo.getUserId(), VSO_People_HR_Department__c=testData.testDepartment.Name,Nationality__c='test', Medical_Clearance_Type__c='Medically cleared for any job',
           Employee_Dependents_Criminally_Cleared__c='Yes', Employee_Dependents_Medically_Cleared__c='Yes', References_Overall_Status__c='References Satisfactory',Criminal_Check_Type__c='Police Check', Entitled_to_HCFA__c='Yes'));
        obcList.add(new OnBoardingCheck__c(RecordTypeId=testData.onboardingRecordType2.Id,Individual_Responsible_for_Completion__c=contactList[2].id,Make_Visible_To_Starter__c=true,Contact__c=contactList[2].id,Offer__c=offerList[2].id,
           Onboarding_Status__c='Onboarding In Progress',Application__c=appList[2].id,Recruitment_Partner__c=accountList[0].id,Relationship_Manager__c=testData.testUser.id,Previous_Engagement__c='First placement'));
        insert obcList;      
        
        testData.testOnboardingList=obcList;
        testData.testAppList=appList;
        testData.testContactList=contactList;
        testData.testAccountList=accountList;

    }
    
     // class used internally for passing a bundle of related test data around
    public class TestRecords {
        public User testUser;
        public Country__c testCountry;
        public RecordType jobRecordType;
        public RecordType offerRecordType1;
        public RecordType offerRecordType2;
        public RecordType onboardingRecordType1;
        public RecordType onboardingRecordType2;
        public fHCM2__Department__c testDepartment;
        public List<OnBoardingCheck__c> testOnboardingList;       
        public List<Application__c> testAppList;
        public List<Contact> testContactList;
        public List<Account> testAccountList;
        
        public TestRecords()
        {           
            testOnboardingList=new List<OnBoardingCheck__c>();
            testAppList=new List<Application__c>();
            testContactList=new List<Contact>();
            testAccountList=new List<Account>();
        }
    }
 }