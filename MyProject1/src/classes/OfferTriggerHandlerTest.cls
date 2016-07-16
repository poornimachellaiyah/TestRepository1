@isTest
private class OfferTriggerHandlerTest {
    
    static testMethod void Offer_CommunityShareTest() {
        
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'share1', email='Application_HiringManagerShare1@testorg.com', 
            emailencodingkey='UTF-8', lastname='Application_HiringManagerShare1', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='Application_HiringManagerShare1@testorg.com');
        
        
            
            list<Country__c> lstCountry = new list<Country__c>();
            list<Job__c> lstJobs = new list<Job__c>();
            list<Application__c> lstApps = new list<Application__c>();
            //prepare a dummy data for Country
            for(integer i=0; i<5;i++){
                Country__c cntry=TestDataClass.getCountry('TestClassCountry'+i);
                lstCountry.add(cntry);
            }
            //insert countries
            insert lstCountry;
            
            List<RecordType> JobRecordTypes=new List<RecordType>();
            JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
            
        System.runAs(u1) {
            
            for(integer i=0; i<1;i++){
                if(i<3){
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
                    lstJobs.add(jb);
                }else{
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
                    lstJobs.add(jb);
                }
            }       
            //insert Jobs 
            insert lstJobs;
            Contact con=new Contact(Firstname='TestSite1',lastname='user1',email='testshare@uk.fujitsu.com',Related_Employee__c=u1.id);
            insert con;
            for(integer i=0; i<1;i++){
                Application__c applc=new Application__c(Applicant__c=con.id ,Send_Decline_Email__c=false, Job__c=lstJobs[i].Id , Submission_Date__c=system.today());
                    lstApps.add(applc);
            }       
            insert lstApps;
            list<Offer__c> lstOffr = new list<Offer__c>();
            for(integer i=0; i<1;i++){
                Offer__c applc=new Offer__c(No_Medical_Email__c=true,Applicant__c=con.id ,Application__c=lstApps[0].id,Status__c='Sent');
                    lstOffr.add(applc);
            }
            insert lstOffr;
            
            for(Offer__c off:lstOffr){
                off.Make_Visible_To_Candidate__c=true;
            }
            try{
                update lstOffr;
            }catch(exception e){
                system.debug('*********error message:'+e.getmessage());
            }
            
            //removing access for offer record from user
            for(Offer__c off:lstOffr){
                off.Make_Visible_To_Candidate__c=false;
            }
            try{
                update lstOffr;
            }catch(exception e){
                system.debug('*********error message:'+e.getmessage());
            }            
        }    
    }
    
    static TestRecords getTestRecords()
    {
        TestRecords testdata=new TestRecords();
        Id countryUser = [ SELECT Id FROM User WHERE UserRoleId != '' AND isActive=true LIMIT 1 ].Id;      
        
        Profile sysAdminProfile = [ SELECT id FROM Profile WHERE name = 'SP_People Group Manager_FSM' ];  
        
        User u1 = 
          new User(
            alias = 'UserT', 
            email = 'TestUser1@testorg.com', 
              emailencodingkey = 'UTF-8', 
              firstname='f1',
              lastname = 'TestUser', 
              languagelocalekey = 'en_US', 
              localesidkey = 'en_US', 
              profileid = sysAdminProfile.Id, 
              timezonesidkey = 'America/Los_Angeles', 
              username = 'updateonboardfieldtest@testorg.com'
            )
    ;
      insert u1;
      User u2 =new User(alias = 'UserT2',email ='TestUser2onboard@testorg.com',emailencodingkey = 'UTF-8',firstname='f2',lastname = 'TestUser2',languagelocalekey = 'en_US', 
              localesidkey = 'en_US',profileid = sysAdminProfile.Id,timezonesidkey = 'America/Los_Angeles',username ='updateonboardfieldtest2@testorg.com');
    	insert u2;
        
        Country__c country = 
          new Country__c(
            Name = 'TestClassCountry', 
            Region__c = 'Europe', 
            Country_People_Manager__c = countryUser, 
            Country_Director__c = countryUser
          )
        ;
        
        insert country;
                
        System.runAs(u1) {
            
            Contact con = new Contact(firstName = 'Test',lastName = 'Test',email='onboardtestcontact@test.com');
            insert con;
            
            Account acc = new Account(Name = 'Test');
            insert acc;
                                           
            List<RecordType> JobRecordTypes=new List<RecordType>();
            JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
            
            Job__c job=new Job__c(Hiring_Manager__c=u1.id,People_Group_Manager__c=u1.id,People_Group_Admin__c=u1.id,Job_Reason__c='jobtest',RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob',Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='IT',Country__c=country.id,Job_Status__c='Approved for Recruitment');
            insert job;
                        
            Application__c appln=new Application__c(Applicant__c=con.id ,Send_Decline_Email__c=false, Job__c=job.Id , Submission_Date__c=system.today());
            insert appln; 
            
            List<RecordType> OfferRecordTypes=new List<RecordType>(); 
            OfferRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND Developername='Employee_Offer'];    
        
            Offer__c offer= new Offer__c(Applicant__c=con.id ,Application__c=appln.id,Status__c='Sent',VSO_Offer_Contact_Person__c=u1.id,RecordTypeid=OfferRecordTypes[0].id,Payroll_Office_processing_location__c=country.id,
            Offer_Status__c='Verbal Offer Accepted');             
            insert offer;    
         
            Offer__c offr=new Offer__c (id=offer.id,Offer_Status__c= 'Conditional Offer Accepted');
            update offr;
            
             Map<String,Id> mapOnBoardingCheckRecdType = new Map<String,Id> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt.id);}
            
            OnBoardingCheck__c OnboardCheck = new OnBoardingCheck__c(RecordTypeId=mapOnBoardingCheckRecdType.get('Employee_Consultant'),Application__c=appln.id,Contact__c=con.id,Recruitment_Partner__c=acc.id,Relationship_Manager__c=u1.id);
            insert OnboardCheck;
            
            fHCM2__Exchange_Rate__c testex=new fHCM2__Exchange_Rate__c(Name='TEST',fHCM2__Currency_Code__c='INR');
            insert testex;
            fHCM2__Salary_Band__c testpayband= new fHCM2__Salary_Band__c(Name='Test Payband',fHCM2__Currency__c=testex.Id,fHCM2__Bottom__c=100000,fHCM2__Top__c=500000,Effective_From__c=System.today(),Country__c=country.Id,Probation_Period__c='3 month');
            insert testpayband;
            
            testdata.testApp=appln;
            testdata.testJob=job;
            testdata.testAccount=acc;
            testdata.usr=u1;
            testdata.testContact=con;
            testdata.testOffer=offer;
            testdata.offerRecordType=OfferRecordTypes[0];
            testdata.Country=country;
            testdata.testSalaryBand=testpayband;
            testdata.testonboard=OnboardCheck;
    	}
        return testdata;
    }
    
    static testMethod void testupdateOfferFields()
    {
        TestRecords t1=getTestRecords();
        Contact con=t1.testContact;
        Application__c app=t1.testApp;
        fHCM2__Salary_Band__c sb=t1.testSalaryBand;
        System.runAs(t1.usr) 
        {
            test.startTest();            
            Offer__c ofr=new Offer__c(Applicant__c=con.id ,Application__c=app.id,Status__c='Sent',Pay_Band__c=sb.Id,RecordTypeid=t1.offerRecordType.Id,Payroll_Office_processing_location__c=t1.Country.Id,
                Offer_Status__c='Verbal Offer Accepted'); 
            insert ofr;            
            test.stopTest();
            Offer__c tOffer=[select id,People_Group_Manager__c,People_Group_Admin__c,VSO_Offer_Contact_Person__c,Probation_Period__c from Offer__c where Application__c=:app.Id order by createddate limit 1];
            system.assertEquals(t1.usr.Id,tOffer.People_Group_Manager__c,'People Group Manager should be autopopulated from job');
            system.assertEquals(t1.usr.Id,tOffer.People_Group_Admin__c,'People Group Admin should be autopopulated from job');
        	system.assertEquals(t1.usr.Id,tOffer.VSO_Offer_Contact_Person__c,'VSO Offer Contact Person should be autopopulated from job');
           // system.assertEquals('3 month',tOffer.Probation_Period__c,'Probation period should be autopopulated');
        }
    }
    
    static testMethod void testUpdateOfferFieldsInOnBoarding()
    {
        TestRecords t2=getTestRecords(); 
        Offer__c toffer=t2.testOffer;
        test.startTest();
        Date testdate=system.today();
        toffer.Proposed_Start_Date__c=testdate;
        toffer.Proposed_End_Date__c=testdate.addYears(1);
        update toffer;
        test.stopTest();
        OnBoardingCheck__c obc=[select id,Proposed_Start_Date__c,Proposed_End_Date__c from OnBoardingCheck__c where application__c=:toffer.Application__c];
        system.assertEquals(testdate,obc.Proposed_Start_Date__c,'Proposed start date should be auto populated');
        system.assertEquals(testdate.addYears(1),obc.Proposed_End_Date__c,'Proposed end date should be auto populated');
    }
    
    static testMethod void testUpdateApplicationStatus()
    {
        TestRecords t3=getTestRecords();
        Offer__c testofr=t3.testOffer;
        test.startTest();
        testofr.Conditional_Offer_Response__c='Accepted';
        update testofr;
        Application__c testapp1=[select id,Status__c from Application__c where id=:testofr.Application__c];
        system.assertEquals('Onboarding in Progress', testapp1.Status__c,'status should be Onboarding in Progress');
        testofr.Conditional_Offer_Response__c='Declined';
        testofr.Conditional_Offer_Decline_Comments__c ='testdecline';
        update testofr;
        Application__c testapp2=[select id,Status__c from Application__c where id=:testofr.Application__c];
        system.assertEquals('Offer Declined', testapp2.Status__c,'status should be Offer Declined');
        test.stopTest();
    }
    
    
    
     // class used internally for passing a bundle of related test data arounds
    public class TestRecords {                
        public Job__c testJob;
        public Application__c testApp;
        public Offer__c testOffer;
        public Contact testContact;
        public Account testAccount;
        Public User usr;
        public RecordType offerRecordType;
        public RecordType onboardRecordType;
        public Country__c Country;
        public fHCM2__Salary_Band__c testSalaryBand;
        public OnBoardingCheck__c testonboard;       
    }
}