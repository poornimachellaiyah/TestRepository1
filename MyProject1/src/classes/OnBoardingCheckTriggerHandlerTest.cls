@isTest
private class OnBoardingCheckTriggerHandlerTest {

    /*
    static testMethod void OnBoardingCheck_CommunityShareUnitTest() {
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
            
            for(integer i=0; i<5;i++){
                if(i<3){
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved by People Group Approver');
                    lstJobs.add(jb);
                }else{
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved by People Group Approver');
                    lstJobs.add(jb);
                }
            }     
            //insert Jobs 
            insert lstJobs;
            Contact con=new Contact(Firstname='TestSite1',lastname='user1',email='testshare@uk.fujitsu.com',Related_Employee__c=u1.id);
            insert con;
            for(integer i=0; i<5;i++){
                Application__c applc=new Application__c(Applicant__c=con.id ,Send_Decline_Email__c=false, Job__c=lstJobs[i].Id , Submission_Date__c=system.today());
                    lstApps.add(applc); 
            }       
            insert lstApps;
            list<Offer__c> lstOffr = new list<Offer__c>();
            for(integer i=0; i<5;i++){
                Offer__c applc=new Offer__c(Applicant__c=con.id ,Application__c=lstApps[0].id,Status__c='Sent');
                    lstOffr.add(applc);
            }
            insert lstOffr;
            
            Map<String,Id> mapOnBoardingCheckRecdType=new Map<String,Id> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt.id);
            }
            list<OnBoardingCheck__c> OnBoardingCheck = new list<OnBoardingCheck__c>();
            for(integer i=0; i<5;i++){
                OnBoardingCheck__c applc=new OnBoardingCheck__c(RecordTypeId=mapOnBoardingCheckRecdType.get('General_On_Boarding_Task'),Contact__c=con.id ,Offer__c=lstOffr[0].id,Status__c='In Progress');
                    OnBoardingCheck.add(applc);
            }
            insert OnBoardingCheck;
            
            for(OnBoardingCheck__c off:OnBoardingCheck){
                off.Make_Visible_To_Starter__c=true;
                off.Individual_Responsible_for_Completion__c=con.id;
            }
            try{
                update OnBoardingCheck;
            }catch(exception e){
                system.debug('*********error message:'+e.getmessage());
            }
            
            
            for(OnBoardingCheck__c off:OnBoardingCheck){
                off.Make_Visible_To_Starter__c=false;
                off.Individual_Responsible_for_Completion__c=null;
            }
            try{
                update OnBoardingCheck;
            }catch(exception e){
                system.debug('*********error message:'+e.getmessage());
            }
            
        }
    }
    
    static testMethod void OnBoardingCheck_UserShareUnitTest() {
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'ohare1', email='OnBoardingCheck_UserShare1@testorg.com', 
            emailencodingkey='UTF-8', lastname='OnBoardingCheck_UserShare1', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='OnBoardingCheck_UserShare1@testorg.com');
        
        
            
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
            
            for(integer i=0; i<5;i++){
                if(i<3){
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved by People Group Approver');
                    lstJobs.add(jb);
                }else{
                    Job__c jb=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved by People Group Approver');
                    lstJobs.add(jb);
                }
            }       
            //insert Jobs 
            insert lstJobs;
            //insert contacts
            List<Contact> contactlist=new List<Contact>();
            for(integer i=0;i<5;i++){
                Contact con=new Contact(Firstname='TestSite'+i,lastname='user'+i,email=i+'testshare@uk.fujitsu.com',Related_Employee__c=u1.id);
                contactlist.add(con);
            }
            insert contactlist;
            
            for(integer i=0; i<5;i++){
                Application__c applc=new Application__c(Applicant__c=contactlist[0].id ,Send_Decline_Email__c=false, Job__c=lstJobs[i].Id , Submission_Date__c=system.today());
                    lstApps.add(applc); 
            }       
            insert lstApps;
            list<Offer__c> lstOffr = new list<Offer__c>();
            for(integer i=0; i<5;i++){
                Offer__c applc=new Offer__c(Applicant__c=contactlist[0].id ,Application__c=lstApps[0].id,Status__c='Sent');
                    lstOffr.add(applc);
            }
            insert lstOffr;
            
            Map<String,Id> mapOnBoardingCheckRecdType=new Map<String,Id> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt.id);
            }
            list<OnBoardingCheck__c> OnBoardingCheck = new list<OnBoardingCheck__c>();
            for(integer i=0; i<5;i++){
                OnBoardingCheck__c applc=new OnBoardingCheck__c(Individual_Responsible_for_Completion__c=contactlist[0].id,Make_Visible_To_Starter__c=true,Contact__c=contactlist[0].id,RecordTypeId=mapOnBoardingCheckRecdType.get('General_On_Boarding_Task'),Offer__c=lstOffr[0].id,Status__c='In Progress');
                    OnBoardingCheck.add(applc);
            }
            insert OnBoardingCheck;
            
            for(OnBoardingCheck__c off:OnBoardingCheck){
                off.Individual_Responsible_for_Completion__c=contactlist[1].id;
            }
            try{
                update OnBoardingCheck;
            }catch(exception e){
                system.debug('*********error message:'+e.getmessage());
            }
            
            
            for(OnBoardingCheck__c off:OnBoardingCheck){
                off.Individual_Responsible_for_Completion__c=null;
            }
            try{
                update OnBoardingCheck;
            }catch(exception e){
                system.debug('*********error message:'+e.getmessage());
            }
            
        }
    }*/
      
   /* static testMethod void OnBoardingCheck_HiringManagerShareUnitTest() 
    {
        Profile p1 = [select id from profile where name='System Administrator'];  
        User u1 = new User(alias = 'ohare2', email='OnBoardingCheck_hiringManagerShare2@testorg.com', 
            emailencodingkey='UTF-8', lastname='OnBoardingCheck_hiringManagerShare2', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='OnBoardingCheck_hiringManagerShare2@testorg.com',isActive=true);
        
            list<Country__c> lstCountry = new list<Country__c>();
            list<Job__c> lstJobs = new list<Job__c>();
            list<Application__c> lstApps = new list<Application__c>();
            //prepare a dummy data for Country
            for(integer i=0; i<1;i++){
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
                    Job__c jb=new Job__c(Hiring_Manager__c=UserInfo.getUserId(),RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
                    lstJobs.add(jb);
                }else{
                    Job__c jb=new Job__c(Hiring_Manager__c=UserInfo.getUserId(),RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob'+i,Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='JT'+i,Country__c=lstCountry[i].id,Job_Status__c='Approved for Recruitment');
                    lstJobs.add(jb);
                }
            }       
            //insert Jobs 
            insert lstJobs;
            //insert contacts
            List<Contact> contactlist=new List<Contact>();
            for(integer i=0;i<2;i++){
                Contact con=new Contact(Firstname='TestSite'+i,lastname='user'+i,email=i+'testshare@uk.fujitsu.com',Related_Employee__c=u1.id);
                contactlist.add(con);
            }
            insert contactlist;
            
            Account acc = new Account(Name='Recruitment Partner - UK');
            insert acc;
            
            for(integer i=0; i<1;i++){
                Application__c applc=new Application__c(Applicant__c=contactlist[0].id ,Send_Decline_Email__c=false, Job__c=lstJobs[i].Id , Submission_Date__c=system.today());
                    lstApps.add(applc); 
            }       
            insert lstApps;
            
            List<RecordType> offerRecordTypes=new List<RecordType>();
            offerRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND (Developername='Employee_Offer' OR Developername='Volunteer_Offer')];
            
            list<Offer__c> lstOffr = new list<Offer__c>();
            for(integer i=0; i<1;i++){
                Offer__c applc=new Offer__c(RecordTypeid=offerRecordTypes[1].id,No_Medical_Email__c=true,Proposed_End_Date__c=system.today()+1,Proposed_Start_Date__c=system.today(),Applicant__c=contactlist[0].id ,Application__c=lstApps[0].id,Status__c='Sent',Offer_Status__c='Conditional Offer Accepted');
                lstOffr.add(applc);
            }
            insert lstOffr;
            
            Application__c app=new Application__c(id=lstApps[0].id,Help_Offer__c=lstOffr[0].id,Help_Offer_Status__c=lstOffr[0].Offer_Status__c );
            update app;
            
            system.debug('TEST'+lstOffr.size());
            
            Map<String,Id> mapOnBoardingCheckRecdType=new Map<String,Id> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt.id);
            }
           OnBoardingCheck__c OnBoardingCheck = new OnBoardingCheck__c(Onboarding_User__c=userinfo.getUserId(),offer__c=lstOffr[0].id,Individual_Responsible_for_Completion__c=contactlist[0].id,Application__c=lstApps[0].id,Recruitment_Partner__c=acc.id,Contact__c=contactlist[0].id,Relationship_Manager__c=u1.id,RecordTypeId=mapOnBoardingCheckRecdType.get('Employee_Consultant'));
           insert OnBoardingCheck;  
           
           //OnBoardingCheck__c OnBoardingCheck2 = new OnBoardingCheck__c(offer__c=lstOffr[0].id,Individual_Responsible_for_Completion__c=contactlist[0].id,Application__c=lstApps[0].id,Recruitment_Partner__c=acc.id,Contact__c=contactlist[0].id,Relationship_Manager__c=u1.id,RecordTypeId=mapOnBoardingCheckRecdType.get('Volunteer'));
           //insert OnBoardingCheck2;  
           
           OnBoardingCheck__c OnBoardingCheck1 = new OnBoardingCheck__c();
           OnBoardingCheck1.id=OnBoardingCheck.id;
           OnBoardingCheck1.Individual_Responsible_for_Completion__c=contactlist[1].id;
           update OnBoardingCheck1;
            
        }
      }
       */
    //Dinesh-TPT-KE Phase-2 Changes-24/August/2015
    //Method created to test KE functionalities 
    static testMethod void OnBoardingCheck_KEUnitTest() 
    {
            Profile p1 = [select id from profile where name='System Administrator'];  
            User u1 = new User(alias = 'ohare2', email='OnBoardingCheck@testorg.com', 
            emailencodingkey='UTF-8', lastname='OnBoardingCheck', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='OnBoardingCheck@testorg.com');
            
            list<Country__c> lstCountry = new list<Country__c>();
            list<Job__c> lstJobs = new list<Job__c>();
            list<Application__c> lstApps = new list<Application__c>();
            
            //Insert country
            Country__c cntry=TestDataClass.getCountry('TestClassCountry');            
            insert cntry;
            
            List<RecordType> JobRecordTypes=new List<RecordType>();
            JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND Developername='Approved_Volunteer_Job'];
            
            System.runAs(u1) {
            
            List<Account> accList=new List<Account>();
            
            Account KEaccount=new Account(Name='Test KE A/c',Contract_Signed__c=true,Medical_Liability__c='Corporate Partner',Insurance_Liability__c='Corporate Partner');
            accList.add(KEaccount);
            
            Account DevAccount=new Account(Name='Test Dev A/c',Medical_Liability__c='Development Partner',Insurance_Liability__c='Corporate Partner');
            accList.add(DevAccount);    
                    
            Insert accList;
            
            //Insert Job  
            List<Job__c> jobList=new List<Job__c>();          
            Job__c job=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,
                                  External_Advert_End_Date__c=system.today()+30,Name='TestJob',Projected_Start_Date__c=system.today()+10,
                                  Demand_Sign_Off_Date__c=null,Job_Title__c='JT',Country__c=cntry.id,Job_Status__c='Approved for Recruitment'
                                  ,Development_Partner__c=accList[1].id,Knowledge_Exchange_Partner__c=accList[0].id);
            jobList.add(job);   
                     
            Insert jobList;
            
            //insert contacts
            List<Contact> contactlist=new List<Contact>();            
            Contact con=new Contact(Corporate_Partner__c=accList[0].id,Knowledge_Exchange_Applicant__c=true,Firstname='TestSite',lastname='user',email='test@testtpt.com',Related_Employee__c=u1.id);
            contactlist.add(con);
            
            Insert contactlist;
            
            Account acc = new Account(Name='Recruitment Partner - UK');
            Insert acc;
            
            //Insert Application
            List<Application__c> appList=new List<Application__c>();
            Application__c app=new Application__c(Applicant__c=contactlist[0].id ,Send_Decline_Email__c=false, Job__c=jobList[0].Id , Submission_Date__c=system.today());
            appList.add(app);            
            
            Insert appList;
            
            //Insert Offer
            List<RecordType> offerRecordTypes=new List<RecordType>();
            offerRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND  Developername='Volunteer_Offer'];
            
            List<Offer__c > offerList=new List<Offer__c >();
            Offer__c offer=new Offer__c(RecordTypeid=offerRecordTypes[0].id,No_Medical_Email__c=true,Proposed_End_Date__c=system.today()+1,Proposed_Start_Date__c=system.today(),Applicant__c=contactlist[0].id,
                                        Application__c=appList[0].id,Status__c='Sent',Offer_Status__c='Conditional Offer Accepted',
                                        Conditional_Offer_Response__c='Accepted',Corporate_Conditional_Offer_Response__c='Accepted');
            offerList.add(offer);
            
            Insert offerList;
            
            //Update Application
            List<Application__c> appListUpdate=new List<Application__c>();
            Application__c app2=new Application__c(id=appList[0].id,Help_Offer__c=offerList[0].id,Help_Offer_Status__c=offerList[0].Offer_Status__c );
            appListUpdate.add(app2);
            
            Update appListUpdate;
            
            //Insert Onboarding
            Map<String,Id> mapOnBoardingCheckRecdType=new Map<String,Id> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt.id);
            }
          
            List<OnBoardingCheck__c> onboardList=new List<OnBoardingCheck__c >();

            OnBoardingCheck__c OnBoard1 = new OnBoardingCheck__c(Onboarding_User__c=userinfo.getUserId(),offer__c=offerList[0].id,Individual_Responsible_for_Completion__c=contactlist[0].id,Application__c=appList[0].id,Recruitment_Partner__c=acc.id,Contact__c=contactlist[0].id,Relationship_Manager__c=u1.id,RecordTypeId=mapOnBoardingCheckRecdType.get('Volunteer'));
            onboardList.add(OnBoard1);
            
            Insert onboardList;
        }
      }
      
      //Dinesh-TPT-KE Phase-2 Changes-24/August/2015
      //Method created to test KE functionalities
      static testMethod void OnBoardingCheck_KEUnitTest2() 
      {
            Profile p1 = [select id from profile where name='System Administrator'];  
            User u1 = new User(alias = 'ohare2', email='OnBoardingCheck@testorg.com', 
            emailencodingkey='UTF-8', lastname='OnBoardingCheck', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='OnBoardingCheck@testorg.com');
            
            list<Country__c> lstCountry = new list<Country__c>();
            list<Job__c> lstJobs = new list<Job__c>();
            list<Application__c> lstApps = new list<Application__c>();
            
            //Insert country
            Country__c cntry=TestDataClass.getCountry('TestClassCountry');            
            insert cntry;
            
            List<RecordType> JobRecordTypes=new List<RecordType>();
            JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND Developername='Approved_Volunteer_Job'];
            
            System.runAs(u1) {
            
            List<Account> accList=new List<Account>();
            
            Account KEaccount=new Account(Name='Test KE A/c',Contract_Signed__c=true,Medical_Liability__c='Corporate Partner',Insurance_Liability__c='Corporate Partner');
            accList.add(KEaccount);
            
            Account DevAccount1=new Account(Name='Test Dev A/c2',Medical_Liability__c='VSO',Insurance_Liability__c='');
            accList.add(DevAccount1);
            
            Insert accList;
            
            //Insert Job  
            List<Job__c> jobList=new List<Job__c>();          
            
            Job__c job1=new Job__c(Hiring_Manager__c=u1.id,RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,
                                  External_Advert_End_Date__c=system.today()+25,Name='TestJob1',Projected_Start_Date__c=system.today()+11,
                                  Demand_Sign_Off_Date__c=null,Job_Title__c='JT1',Country__c=cntry.id,Job_Status__c='Approved for Recruitment'
                                  ,Development_Partner__c=accList[1].id,Knowledge_Exchange_Partner__c=accList[0].id);
            jobList.add(job1);
            
            Insert jobList;
            
            //insert contacts
            List<Contact> contactlist=new List<Contact>();            
           
            Contact con1=new Contact(Corporate_Partner__c=accList[0].id,Knowledge_Exchange_Applicant__c=true,Firstname='TestSite1',lastname='user1',email='test1@testtpt.com',Related_Employee__c=u1.id);
            contactlist.add(con1);
            
            insert contactlist;
            
            Account acc = new Account(Name='Recruitment Partner - UK');
            insert acc;
            
            //Insert Application
            List<Application__c> appList=new List<Application__c>();
            
            Application__c app1=new Application__c(Applicant__c=contactlist[0].id ,Send_Decline_Email__c=false, Job__c=jobList[0].Id , Submission_Date__c=system.today());
            appList.add(app1);
            
            insert appList;
            
            //Insert Offer
            List<RecordType> offerRecordTypes=new List<RecordType>();
            offerRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND  Developername='Volunteer_Offer'];
            
            List<Offer__c > offerList=new List<Offer__c >();
            
            Offer__c offer1=new Offer__c(RecordTypeid=offerRecordTypes[0].id,No_Medical_Email__c=true,Proposed_End_Date__c=system.today()+1,Proposed_Start_Date__c=system.today(),Applicant__c=contactlist[0].id,
                                        Application__c=appList[0].id,Status__c='Sent',Offer_Status__c='Conditional Offer Accepted',
                                        Conditional_Offer_Response__c='Accepted',Corporate_Conditional_Offer_Response__c='Accepted');
            offerList.add(offer1);
            
            insert offerList;
            
            //Update Application
            List<Application__c> appListUpdate=new List<Application__c>();
            
            Application__c app3=new Application__c(id=appList[0].id,Help_Offer__c=offerList[0].id,Help_Offer_Status__c=offerList[0].Offer_Status__c );
            appListUpdate.add(app3);
            
            update appListUpdate;
            
            fHCM2__Department__c dept = new fHCM2__Department__c();
            dept.name  = 'Vol - VSO UK / Cameroon';
            insert dept;
            
            //Insert Onboarding
            Map<String,Id> mapOnBoardingCheckRecdType=new Map<String,Id> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt.id);
            }
              
            List<OnBoardingCheck__c> onboardList=new List<OnBoardingCheck__c >();
            
            OnBoardingCheck__c OnBoard2 = new OnBoardingCheck__c(Onboarding_User__c=userinfo.getUserId(),offer__c=offerList[0].id,Individual_Responsible_for_Completion__c=contactlist[0].id,
                                                                Application__c=appList[0].id,Recruitment_Partner__c=acc.id,Contact__c=contactlist[0].id,Relationship_Manager__c=u1.id,
                                                                RecordTypeId=mapOnBoardingCheckRecdType.get('Volunteer'),Onboarding_Status__c = 'Cleared to Start',Cleared_to_Start_Date__c = date.today(),
                                                                Confirmed_Start_of_Service_Date__c = date.today().addDays(5),Criminal_Background_Clearance_Status__c = 'Cleared',
                                                                Criminal_Background_Clearance_Date__c =date.today().addDays(-10),Criminal_Background_Reviewer__c = UserInfo.getUserId(),
                                                                Vol_Accomp_Partner_Criminally_Cleared__c = 'n/a',VSO_People_HR_Department__c = 'Vol - VSO UK / Cameroon',Nationality__c='Test',
                                                                Continuing_Assessment_Status__c='No Concern',Criminal_Check_Type__c='Police Check',Entitled_to_HCFA__c='No');
            onboardList.add(OnBoard2);
            
            Insert onboardList;
        }
      }
    
     // class used internally for passing a bundle of related test data arounds
    public class TestRecords {                
        public List<Job__c> testJob;
        public List<Application__c> testApp;
        public List<Offer__c> testOffer;
        public List<Contact> testContact;
        public Account testAccount;
        Public User usr;
        public RecordType offerRecordType;
        public RecordType onboardRecordType;
        public Country__c Country;       
        public OnBoardingCheck__c testonboard;       
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
            
            List<Contact> contacts=new List<Contact>();
            Contact con1 = new Contact(firstName = 'Test',lastName = 'Test',email='onboardtestcontact1@test.com');
            contacts.add(con1);
            Contact con2=new Contact(firstName = 'Test1',lastName = 'Test1',email='onboardtestcontact2@test.com');
            contacts.add(con2);
            insert contacts;
            
            Account acc = new Account(Name = 'Test');
            insert acc;
                                           
            List<RecordType> JobRecordTypes=new List<RecordType>();
            JobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
            
            List<Job__c> jobs=new List<Job__c>();
            Job__c job1=new Job__c(Hiring_Manager__c=u1.id,People_Group_Manager__c=u1.id,People_Group_Admin__c=u1.id,Job_Reason__c='jobtest',RecordTypeid=JobRecordTypes[0].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob1',Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='ITTESTJOB1',Country__c=country.id,Job_Status__c='Approved for Recruitment');
            jobs.add(job1);
            Job__c job2=new Job__c(Hiring_Manager__c=u1.id,People_Group_Manager__c=u1.id,People_Group_Admin__c=u1.id,Job_Reason__c='jobtest',RecordTypeid=JobRecordTypes[1].id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name='TestJob2',Projected_Start_Date__c=system.today()+10, Demand_Sign_Off_Date__c=null,Job_Title__c='ITTESTJOB2',Country__c=country.id,Job_Status__c='Approved for Recruitment');
            jobs.add(job2);
            insert jobs;            
            
            List<Application__c> applications=new List<Application__c>();
            Application__c appln1=new Application__c(Applicant__c=contacts[0].id ,Send_Decline_Email__c=false, Job__c=jobs[0].Id , Submission_Date__c=system.today());
            applications.add(appln1);
            Application__c appln2=new Application__c(Applicant__c=contacts[1].id ,Send_Decline_Email__c=false, Job__c=jobs[1].Id , Submission_Date__c=system.today());
            applications.add(appln2);
            insert applications; 
            
            List<RecordType> OfferRecordTypes=new List<RecordType>(); 
            OfferRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND (Developername='Employee_Offer' OR Developername='Volunteer_Offer')];    
        
            fHCM2__Exchange_Rate__c testex=new fHCM2__Exchange_Rate__c(Name='TEST',fHCM2__Currency_Code__c='INR');
            insert testex;
            fHCM2__Salary_Band__c testpayband= new fHCM2__Salary_Band__c(Name='Test Payband',fHCM2__Currency__c=testex.Id,fHCM2__Bottom__c=100000,fHCM2__Top__c=500000,Effective_From__c=System.today(),Country__c=country.Id,Probation_Period__c='3 month');
            insert testpayband;
            
            List<Offer__c> offers=new List<Offer__c>();
            Offer__c offer1= new Offer__c(Applicant__c=contacts[0].id ,Pay_Band__c=testpayband.id,Application__c=applications[0].id,Status__c='Sent',VSO_Offer_Contact_Person__c=u1.id,RecordTypeid=OfferRecordTypes[0].id,Payroll_Office_processing_location__c=country.id,
            Offer_Status__c='Verbal Offer Accepted');
            offers.add(offer1);
            Offer__c offer2= new Offer__c(Applicant__c=contacts[1].id ,Application__c=applications[1].id,Status__c='Sent',VSO_Offer_Contact_Person__c=u1.id,RecordTypeid=OfferRecordTypes[1].id,Offer_Status__c='Verbal Offer Accepted');
            offers.add(offer2);
            insert offers;    
         
            Offer__c offr1=new Offer__c (id=offers[0].id,Offer_Status__c= 'Conditional Offer Accepted');
            update offr1;
            Offer__c offr2=new Offer__c (id=offers[1].id,Offer_Status__c= 'Conditional Offer Accepted');
            update offr2;
            
             Map<String,RecordType> mapOnBoardingCheckRecdType = new Map<String,RecordType> ();
            for(RecordType rt:[select id,name,developername from RecordType where SobjectType='OnBoardingCheck__c']){
                mapOnBoardingCheckRecdType.put(rt.developername,rt);}         
          
            
            testdata.testApp=applications;
            testdata.testJob=jobs;
            testdata.testAccount=acc;
            testdata.usr=u1;
            testdata.testContact=contacts;
            testdata.testOffer=offers;
            testdata.offerRecordType=OfferRecordTypes[0];
            testdata.Country=country;  
            testdata.onboardRecordType=mapOnBoardingCheckRecdType.get('Employee_Consultant');
        }
        return testdata;
    }
    
    static testMethod void testUpdateOfferFieldsInOnboarding()
    {
        TestRecords t1=getTestRecords();
        Application__c app=t1.testApp[0];
        Offer__c ofr=[select id from Offer__c where Application__c=:app.Id];
        Date testdate=system.today();
        ofr.Proposed_Start_Date__c=testdate;
        ofr.Proposed_End_Date__c=testdate.addYears(1);
        ofr.People_Group_Manager__c=t1.usr.Id;
        ofr.People_Group_Admin__c=t1.usr.Id;
        update ofr;
        test.startTest();
        OnBoardingCheck__c OnboardCheck = new OnBoardingCheck__c(RecordTypeId=t1.onboardRecordType.Id,Application__c=app.Id,Contact__c=t1.testContact[0].id,Recruitment_Partner__c=t1.testAccount.id,Relationship_Manager__c=t1.usr.id);
        insert OnboardCheck; 
        test.stopTest();
        OnBoardingCheck__c createdonb=[select id,Proposed_Start_Date__c,Proposed_End_Date__c,People_Group_Manager__c,People_Group_Admin__c from OnBoardingCheck__c where Application__c=:app.Id];
        system.assertEquals(testdate,createdonb.Proposed_Start_Date__c,'Proposed start date should be auto populated');
        system.assertEquals(testdate.addYears(1),createdonb.Proposed_End_Date__c,'Proposed end date should be auto populated');
        system.assertEquals(t1.usr.Id,createdonb.People_Group_Manager__c,'People Group Manager should be autopopulated from offer');
        system.assertEquals(t1.usr.Id,createdonb.People_Group_Admin__c,'People Group Admin should be autopopulated from offer');      
    }
      
    static testmethod void testUpdateOnboardField()
    {
        TestRecords t1=getTestRecords();
        List<Application__c> lstapp=new List<Application__c>();
        Application__c app1= [Select id,Referee_1_First_Name__c,Referee_1_Last_Name__c,Referee_1_Relationship_To_You__c,Referee_1_Relationship_To_You_Other__c,Referee_1_Job_Title__c,Referee_1_Organisation__c,Referee_1_Email__c,Referee_1_Telephone__c,Referee_1_Approach_Before_Offer__c from Application__c where id=:t1.testApp[0].Id];
        Application__c app2= [Select id,Referee_1_First_Name__c,Referee_1_Last_Name__c,Referee_1_Relationship_To_You__c,Referee_1_Relationship_To_You_Other__c,Referee_1_Job_Title__c,Referee_1_Organisation__c,Referee_1_Email__c,Referee_1_Telephone__c,Referee_1_Approach_Before_Offer__c from Application__c where id=:t1.testApp[1].Id];
        app1.Referee_1_First_Name__c='Test';
        app1.Referee_1_Email__c='test1@test.com';
        app1.Referee_1_Last_Name__c='test';
        app1.Referee_1_Job_Title__c='test';
        lstapp.add(app1);
        app2.Referee_1_First_Name__c='Test2';
        app2.Referee_1_Email__c='test2@test.com';
        app2.Referee_1_Last_Name__c='test2';
        app2.Referee_1_Job_Title__c='test2';
        lstapp.add(app2);
        update lstapp;
        test.startTest();
        List<OnBoardingCheck__c> lstonb=new List<OnBoardingCheck__c>();
        OnBoardingCheck__c OnboardCheck1 = new OnBoardingCheck__c(RecordTypeId=t1.onboardRecordType.Id,Application__c=app1.Id,Contact__c=t1.testContact[0].id,Recruitment_Partner__c=t1.testAccount.id,Relationship_Manager__c=t1.usr.id);
        lstonb.add(OnboardCheck1);
        OnBoardingCheck__c OnboardCheck2 = new OnBoardingCheck__c(RecordTypeId=t1.onboardRecordType.Id,Application__c=app2.Id,Contact__c=t1.testContact[1].id,Recruitment_Partner__c=t1.testAccount.id,Relationship_Manager__c=t1.usr.id);
        lstonb.add(OnboardCheck2);
        insert lstonb;
        test.stopTest();
        OnBoardingCheck__c onb1=[select id,Referee_1_First_Name__c,Referee_1_Last_Name__c from OnBoardingCheck__c where id=:lstonb[0].Id];
        System.assertEquals('Test',onb1.Referee_1_First_Name__c,'Referee 1 Firstname should be updated from application');
        System.assertEquals('test',onb1.Referee_1_Last_Name__c,'Referee 1 lastname should be updated from application');
        OnBoardingCheck__c onb2=[select id,Referee_1_First_Name__c,Referee_1_Last_Name__c from OnBoardingCheck__c where id=:lstonb[1].Id];
        System.assertEquals('Test2',onb2.Referee_1_First_Name__c,'Referee 1 Firstname should be updated from application');
        System.assertEquals('test2',onb2.Referee_1_Last_Name__c,'Referee 1 lastname should be updated from application');
    }
}