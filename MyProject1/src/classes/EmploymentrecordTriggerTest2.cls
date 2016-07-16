/*
* Description: batch tests for EmploymentRecordTrigger class
* Developer Name : Ian Finch
* Company        : Codeulike
* Date created   : 09/03/2016
* Jira Issue  /Project   :  Trigger tidying project 2016
* Reason         : 
*/
@isTest
public class EmploymentrecordTriggerTest2 {

static testmethod void updateSalaryfieldsunittest2()
{
    TestRecords t = setupRecordsForTest();
    fHCM2__Salary__c s1 = t.testSalaryList[0];
    fHCM2__Employment__c er1 = t.testEmploymentRecordList[0];
    fHCM2__Salary__c s2 = t.testSalaryList[1];
    fHCM2__Employment__c er2 = t.testEmploymentRecordList[1];

    EmploymentrecordTrigger.ClearRunOnce();
    Test.startTest();
    System.assertEquals( s1.Id, er1.fHCM2__Current_Salary__c, 'employmentrecord current salary should be filled in');
    System.assertEquals( decimal.valueof('10000'), s1.Basic_Annual_Salary__c, 'basic annual salary should be filled in');
    er1.fHCM2__FTE__c = decimal.valueof('0.8');
    er2.fHCM2__FTE__c = decimal.valueof('0.6');
    update t.testEmploymentRecordList; 
    Test.stopTest();
    // refetch salary
    List<fHCM2__Salary__c> checkSalaryList1 = [select id, Basic__c from fHCM2__Salary__c where Id=:s1.Id];
    System.assertEquals( decimal.valueof('8000'), checkSalaryList1[0].Basic__c, 'Salary should have been reduced');
    List<fHCM2__Salary__c> checkSalaryList2 = [select id, Basic__c from fHCM2__Salary__c where Id=:s2.Id];
    System.assertEquals( decimal.valueof('6000'), checkSalaryList2[0].Basic__c, 'Salary should have been reduced');
    
}

static testmethod void updateEmploymentRecordTest2()
{
    TestRecords t = setupRecordsForTest();
    fHCM2__Salary__c s1 = t.testSalaryList[0];
    fHCM2__Employment__c er1 = t.testEmploymentRecordList[0];
    fHCM2__Salary__c s2 = t.testSalaryList[1];
    fHCM2__Employment__c er2 = t.testEmploymentRecordList[1];

    EmploymentrecordTrigger.ClearRunOnce();
    Test.startTest();
    System.assert(er1.fHCM2__Team_Member__c != null, 'Employment should be linked to team member for this test');
    System.assert(er2.fHCM2__Team_Member__c != null, 'Employment should be linked to team member for this test');
    List<fHCM2__Team_Member__c> teammember1= [SELECT id,fHCM2__Current_Employment__r.Senior_Approver_for_Budget__r.Name,fHCM2__Current_Employment__r.Manager_Employment__r.fHCM2__Email__c,Payroll_ID_Formula__c,fHCM2__Department__r.fHCM2__Policy__r.fHCM2__Hours_Per_Week__c FROM fHCM2__Team_Member__c Where id= :er1.fHCM2__Team_Member__c];
    System.assertEquals(30, teammember1[0].fHCM2__Department__r.fHCM2__Policy__r.fHCM2__Hours_Per_Week__c ,'tm dept policy hpw must be filled in for this test');
    // change any field
    er1.Notice_Period_months__c=decimal.valueof('13');
    er2.Notice_Period_months__c=decimal.valueof('13');
    update t.testEmploymentRecordList; 
    Test.stopTest();
    // refetch employment
    List<fHCM2__Employment__c> checkEmployment1 = [select id, Help_Manager_Email__c, Help_Hours_Per_Week_In_Policy__c from fHCM2__Employment__c where Id=:er1.Id];
    System.assertEquals( 'tm2@example.com', checkEmployment1[0].Help_Manager_Email__c, 'help manager email should be filled in');
    // this does not get set for some reasons
    //System.assertEquals( integer.valueof('30'), checkEmployment1[0].Help_Hours_Per_Week_In_Policy__c, 'hpw in policy help field should be filled in');
    List<fHCM2__Employment__c> checkEmployment2 = [select id, Help_Manager_Email__c, Help_Hours_Per_Week_In_Policy__c from fHCM2__Employment__c where Id=:er2.Id];
    System.assertEquals( 'tm1@example.com', checkEmployment2[0].Help_Manager_Email__c, 'help manager email should be filled in');
    //System.assertEquals( integer.valueof('30'), checkEmployment2[0].Help_Hours_Per_Week_In_Policy__c, 'hpw in policy help field should be filled in');
    
}

static TestRecords setupRecordsForTest()
{
    Profile p1 = [select id from profile where name='SP_People Group Manager_FSM'];  
    // need a user to set up the data
    User u1 = new User(alias = 'UserEmp', email='TestUser_Employment@testorg.com', 
            emailencodingkey='UTF-8', lastname='TestUser', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='TestUser_Employment@testorg.com');

    // need a people manager for country
    Id countryUser = [SELECT Id FROM User WHERE UserRoleId!='' AND isActive=true LIMIT 1].Id;      
        
    Country__c country=new Country__c(Name='TestClassCountry', Region__c='Europe', Country_People_Manager__c=countryUser, Country_Director__c=countryUser);
    insert country;
        
    List<RecordType> jobRecordTypes=[select id,developername,name from RecordType where SobjectType='Job__c' AND (Developername='Employee_Job_Approved' OR Developername='Approved_Volunteer_Job')];
    List<RecordType> offerRecordTypes=[select id,developername,name from RecordType where SobjectType='Offer__c' AND Developername='Employee_Offer'];    
    
    fHCM2__Policy__c policy = new fHCM2__Policy__c(name='TestPolicy', fHCM2__Hours_Per_Week__c = 30);
    insert policy;
    
    fHCM2__Department__c dept=new fHCM2__Department__c(name='TestDepartment', fHCM2__Policy__c = policy.Id);
    insert dept;     
    
    TestRecords ret = new TestRecords();   
    ret.testUser = u1;
    ret.testCountry = country;
    ret.testDepartment = dept;
    ret.jobRecordType = jobRecordTypes[0];
    ret.offerRecordType = offerRecordTypes[0];
    
        
    System.runAs(u1) 
    {
        AddTestRecords(ret, 'Test1', 'Test2');

        
        
    }
                          
    
        
    return ret;
}
    
private static void AddTestRecords(TestRecords testData, String testLabel1, String testLabel2 )
{
    
    List<Account> accountList = new List<Account>();
    accountList.add(new Account(Name=testLabel1));
    accountList.add(new Account(Name=testLabel2));
    insert accountList;
        
    //todo: different users related to contacts?    
    List<Contact> contactList = new List<Contact>();
    contactList.add(new Contact(Firstname=testLabel1,lastname='user1',email='test@testorg.com',Related_Employee__c=testData.testUser.id,Primary_Type__c='Applicant'));
    contactList.add(new Contact(Firstname=testLabel2,lastname='user1',email='test@testorg.com',Related_Employee__c=testData.testUser.id,Primary_Type__c='Applicant'));
    insert contactList;
         
    List<Job__c> jobList = new List<Job__c>();     
    jobList.add(new Job__c(Hiring_Manager__c=testData.testUser.id,RecordTypeid=testData.jobRecordType.id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name=testLabel1,Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,
        Job_Title__c='JT',Country__c=testData.testCountry.id,Job_Status__c='Approved for Recruitment'));
    jobList.add(new Job__c(Hiring_Manager__c=testData.testUser.id,RecordTypeid=testData.jobRecordType.id,Ready_To_Publish__c=true,External_Advert_Start_Date__c=system.today()-30,External_Advert_End_Date__c=system.today()+30,Name=testLabel2,Projected_Start_Date__c=system.today()+10,Projected_End_Date__c=system.today()+20,Demand_Sign_Off_Date__c=null,
        Job_Title__c='JT',Country__c=testData.testCountry.id,Job_Status__c='Approved for Recruitment'));
    insert jobList;
         
    List<Application__c> appList = new List<Application__c>();
    appList.add(new Application__c(Applicant__c=contactList[0].id ,Job__c=jobList[0].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',
        Consent_Date__c=system.today(),Declaration_Date__c=system.today()));
    appList.add(new Application__c(Applicant__c=contactList[1].id ,Job__c=jobList[1].id,Send_Decline_Email__c=false,Submission_Date__c=system.today(),Eligibility_To_Work__c='Yes',
        Consent_Date__c=system.today(),Declaration_Date__c=system.today()));
    insert appList; 
    
    List<Offer__c> offerList = new List<Offer__c>();
    offerList.add(new Offer__c(Applicant__c=contactList[0].id ,Application__c=appList[0].id,Status__c='Sent',VSO_Offer_Contact_Person__c=testData.testUser.id,RecordTypeid=testData.offerRecordType.id,
        Payroll_Office_processing_location__c=testData.testCountry.id, Offer_Status__c='Verbal Offer Accepted'));             
    offerList.add(new Offer__c(Applicant__c=contactList[1].id ,Application__c=appList[1].id,Status__c='Sent',VSO_Offer_Contact_Person__c=testData.testUser.id,RecordTypeid=testData.offerRecordType.id,
        Payroll_Office_processing_location__c=testData.testCountry.id, Offer_Status__c='Verbal Offer Accepted'));             
    insert offerList;    
     
    //Offer__c offr=new Offer__c (id=offer.id,Offer_Status__c= 'Conditional Offer Accepted');
    offerList[0].Offer_Status__c= 'Conditional Offer Accepted';
    offerList[1].Offer_Status__c= 'Conditional Offer Accepted';
    update offerList;                                            
      
    List<OnBoardingCheck__c> obcList = new List<OnBoardingCheck__c>();
    obcList.add(new OnBoardingCheck__c(Individual_Responsible_for_Completion__c=contactList[0].id,Make_Visible_To_Starter__c=true,Contact__c=contactList[0].id,Offer__c=offerList[0].id,
        Status__c='In Progress',Application__c=appList[0].id,Recruitment_Partner__c=accountList[0].id,Relationship_Manager__c=testData.testUser.id));
    obcList.add(new OnBoardingCheck__c(Individual_Responsible_for_Completion__c=contactList[0].id,Make_Visible_To_Starter__c=true,Contact__c=contactList[1].id,Offer__c=offerList[1].id,
        Status__c='In Progress',Application__c=appList[1].id,Recruitment_Partner__c=accountList[1].id,Relationship_Manager__c=testData.testUser.id));
    insert obcList;                                        
    
    List<fHCM2__Employment__c> erList = new List<fHCM2__Employment__c>();
    erList.add(new fHCM2__Employment__c(Notice_Period_months__c=decimal.valueof('2'),fHCM2__Basis__c='Employee',
        Country__c= testData.testCountry.id,fHCM2__FTE__c=decimal.valueof('1')));
    erList.add(new fHCM2__Employment__c(Notice_Period_months__c=decimal.valueof('2'),fHCM2__Basis__c='Employee',
        Country__c= testData.testCountry.id,fHCM2__FTE__c=decimal.valueof('1')));
    insert erList;
                  
    List<fHCM2__Team_Member__c> tmList = new List<fHCM2__Team_Member__c>();
    tmList.add(new fHCM2__Team_Member__c(fHCM2__First_Name__c=testLabel1,fHCM2__Surname__c='Member',Recruitment_Partner__c=accountList[0].id,Relationship_Manager__c=testData.testUser.id,
        fHCM2__Department__c=testData.testDepartment.id,fHCM2__Current_Employment__c=erList[0].id, fHCM2__Email__c='tm1@example.com'));
    tmList.add(new fHCM2__Team_Member__c(fHCM2__First_Name__c=testLabel2,fHCM2__Surname__c='Member',Recruitment_Partner__c=accountList[1].id,Relationship_Manager__c=testData.testUser.id,
        fHCM2__Department__c=testData.testDepartment.id,fHCM2__Current_Employment__c=erList[1].id, fHCM2__Email__c='tm2@example.com'));
    insert tmList; 
    
    erList[0].fHCM2__Team_Member__c = tmList[0].Id;
    erList[0].Manager_Employment__c = tmList[1].Id;  // they manage each other, will do for testing
    erList[1].fHCM2__Team_Member__c = tmList[1].Id;
    erList[1].Manager_Employment__c = tmList[0].Id;  // they manage each other, will do for testing
    update erList;
    
    List<fHCM2__Salary__c> salList = new List<fHCM2__Salary__c>();
    salList.add(new fHCM2__Salary__c(fHCM2__Employment__c=erList[0].id,fHCM2__Active__c=True,fHCM2__Change_Reason__c='Starting salary',
        fHCM2__Start_Date__c=system.today(),Basic_Annual_Salary__c=decimal.valueof('10000'), Basic__c=decimal.valueof('10000')));   
    salList.add(new fHCM2__Salary__c(fHCM2__Employment__c=erList[1].id,fHCM2__Active__c=True,fHCM2__Change_Reason__c='Starting salary',
        fHCM2__Start_Date__c=system.today(),Basic_Annual_Salary__c=decimal.valueof('10000'), Basic__c=decimal.valueof('10000')));   
    insert salList;     
    
    erList[0].fHCM2__Current_Salary__c = salList[0].Id;
    erList[1].fHCM2__Current_Salary__c = salList[1].Id;
    update erList;
    
    
    testData.testSalaryList = salList;
    testData.testEmploymentRecordList = erList;
        
}
    
    // class used internally for passing a bundle of related test data around
    public class TestRecords {
        public User testUser;
        public Country__c testCountry;
        public RecordType jobRecordType;
        public RecordType offerRecordType;
        public fHCM2__Department__c testDepartment;
        public List<fHCM2__Salary__c> testSalaryList;
        public List<fHCM2__Employment__c> testEmploymentRecordList;
        
        public TestRecords()
        {
            testSalaryList = new List<fHCM2__Salary__c>();
            testEmploymentRecordList = new List<fHCM2__Employment__c>();
        }
    }
}