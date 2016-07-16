/* * Created By: Dinesh -TPT
   * Project Name: AVI Job Integration
   * Created Date: (19-Apr-2016)
   * Description:
        1. Generate CSV file about the Applicant details
        2. Send the Applicant details and also the Applicant CV/Resume to the AVI admin user via email
*/

global class SendApplicantDetailsToAVI implements Database.Batchable<sObject>,Database.Stateful{


global Database.QueryLocator start(Database.BatchableContext BC){
    String query = 'SELECT id,Name,Applicant__r.Name,Assigned_Recruitment_Partner__r.Name,Available_for__c,'
                        +'Available_From__c,Available_To__c,Applicant_First_Name__c,Applicant__r.LastName,'
                        +'Applicant__r.Preferred_Name__c,Preferred_Email__c,Current_Education_Level__c,'
                        +'Applicant__r.Primary_Skill__c,Skype_User_Name__c,Applicant__r.npe01__Home_Address__c,'
                        +'Applicant__r.HomePhone,Gender__c,Applicant__r.npe01__WorkPhone__c,Evidence_To_Support_Job_Criteria__c,'
                        +'Preferred_Phone__c,Applicant__r.MobilePhone,Help_Address__c,Applicant__r.MailingCountry FROM Application__c WHERE Is_Email_Sent_to_AVI__c=false AND ' 
                        +'Assigned_Recruitment_Partner__r.Name=\'Recruitment Partner - AVI\' ORDER BY CreatedDate';    
    return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC,List<Application__c> lstApp)
{
    try
    {  
        
        List<Messaging.SingleEmailMessage> mailsList=new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress[] owea = [SELECT Id from OrgWideEmailAddress where Address =:'noreply@vsoint.org'];
        
        for(Application__c a:lstApp)
        {
            List<Attachment> attList = [SELECT Id, Name, ContentType, Body FROM Attachment WHERE parentid =: a.Id];
           
            string colHeader='Full Name, Application Id, Assigned Recruitment Partner, Available For (Months),'
                              +' Available From, Available To, First Name, Last Name, Preferred Name, Preferred Email,'
                              +' Current Education Level, Primary Skill, Skype User Name, '
                              +' Home Phone, Mobile Phone, Preferred Phone, Home Address, Primary Country \n';
                              
            string finalstr=colHeader;
        
             System.debug('Test Narpavi:'+a.Applicant__r.npe01__Home_Address__c);
            string recordString= a.Applicant__r.Name+','+a.Name+','+a.Assigned_Recruitment_Partner__r.Name+','+a.Available_for__c+','+
                                 a.Available_From__c+','+a.Available_To__c+','+a.Applicant_First_Name__c+','+a.Applicant__r.LastName+','+
                                 a.Applicant__r.Preferred_Name__c+','+a.Preferred_Email__c+','+a.Current_Education_Level__c+','+
                                 a.Applicant__r.Primary_Skill__c+','+a.Skype_User_Name__c+','+
                                 a.Applicant__r.HomePhone+','+a.Applicant__r.MobilePhone+','+
                                 a.Preferred_Phone__c+','+a.Help_Address__c+','+a.Applicant__r.MailingCountry+'\n';
            
            finalstr=finalstr+recordString; 
            System.debug('Test Narpavi1:'+a.Help_Address__c);
              
            //Logic to create a csv file to populate Applicant details
            List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
            Messaging.EmailFileAttachment csvAtt = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvName= a.Name+'_Applicant.csv';
            csvAtt.setFileName(csvName);
            csvAtt.setBody(csvBlob);
            efaList.add(csvAtt);
            
            //Lgic to attach the Applicant CV/Resume to the email
            if(attList.size()>0)
            {
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attList [0].Name);
                efa.setBody(attList [0].Body);
                efa.setContentType(attList [0].ContentType);
                efaList.add( efa );
            }
        
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();  
            VSO_Settings__c vso=VSO_Settings__c.getInstance(); 
            string aviEmailid;  
            if(vso.AVI_Admin_Email_id__c!=null){
              aviEmailid= vso.AVI_Admin_Email_id__c;
            }   
                         
            
            String[] toAddresses = new list<string> {aviEmailid};                            
            String subject ='Applicant CSV';
            email.setSubject(subject);           
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }  
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Applicant CSV');
            email.setFileAttachments(efaList); 
            mailsList.add(email);       
        }
    
        
        Messaging.SendEmailResult [] results = Messaging.sendEmail(mailsList);  
        if (results[0].success) 
        {
            List<Application__c> lstToUpdateApp=new List<Application__c>();
            
            for(Application__c a:lstApp){
                a.Is_Email_Sent_to_AVI__c=true;
                lstToUpdateApp.add(a);
            }       
             if(lstToUpdateApp.size()>0){
               update lstToUpdateApp;
            }
        }
    
    }
    
    Catch(Exception ex)
    {
         string errorMsg='Error in Sending Applicant details to AVI Admin \n'+Ex.getmessage();
         string errorClass='SendApplicantDetailsToAVI ';
         string errorStack=Ex.getStackTraceString();
         string errorType=Ex.getTypeName();
         //log the exception
         ApplicationErrorLogController obj=new ApplicationErrorLogController();
         obj.logError(errorClass,errorMsg,errorStack,errorType);    
         system.debug('Unit1 '+errorMsg+' '+errorStack);
    }

}

global void finish(Database.BatchableContext BC){
}
    

}