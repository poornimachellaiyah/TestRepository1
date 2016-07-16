/*
******************************************************************   
 Change log:Code Streamlining. Search Tag : TPT-(18-Nov-2015)
 
   Modified date:6 Apr 2016
   Modified by: Poornima-TPT
   Purpose:Code Refactoring (Code bulkification)
   Search Tag : refactoring      
   
   Modified date:25 Feb 2016
   Modified by: Narpavi-TPT
   Purpose:Employee O&O change to set read access for the Hiring Manager once the offer record is approved.  
   Search Tag : TPT-(25-Feb-2016)
   
   Modified date:1 March 2016
   Modified by:Narpavi-TPT
   purpose:SCR-3:Populate the probation and notice period in offer for fixed term contract type employee
   Search Tag:TPT-(1-March-2015)
                    
****************************************************************** 
*/ 

public without sharing class OfferTriggerHandler {
public boolean isApplicationValid;
       
    private OfferTriggerHandler(){
        isApplicationValid=false;
        if(!trigger.isExecuting){
            throw new InternalException('Not in Trigger context!');
        }
    }

    public void execute(){

     
        if(trigger.isBefore){
            if(trigger.isInsert){
                //
            }else if(trigger.isUpdate){
                this.OfferCommunityShare();
            }else if(trigger.isDelete){
                //
            }else if(trigger.isUnDelete){
                //
            }                               
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                
                 //Narpavi-TPT-(18-Nov-2015)-(SS-4694129)-Code Streamlining                              
                //this.offerHiringManagerShareOnInsert();    
                this.updateOfferFields();                                 
            }
            if(trigger.isUpdate || trigger.isInsert)
            {
               this.updateApplicationStatus(); 
               this.applyOfferCountrySharing();                                                 
            }
            if(trigger.isUpdate)
            {               
               this.updateOfferFieldsInOnBoarding(); 
                                               
            }
        }
    }

public void applyOfferCountrySharing(){
        List<Offer__c> scope = trigger.new;
        Map<Id, Offer__c> offerCountry = new Map<Id, Offer__c>([SELECT Id, 
                                                                            Application__r.Job__r.Type__c,
                                                                            Application__r.Job__r.Country__r.Name, 
                                                                            Application__r.Job__r.Country__r.Country_People_Manager__c,
                                                                            Application__r.Job__r.Country__r.Country_Director__c,
                                                                            Application__r.Job__r.Hiring_Manager__c,Application__r.Job__r.People_Group_Manager__r.id,Application__r.Job__r.Hiring_Manager__r.id FROM Offer__c WHERE Id IN :scope]);    
        List<Offer__Share> offerShares = new List<Offer__Share>();   
          try{          
             if(trigger.isInsert)
             { 
                  for(Offer__c o : scope) 
                  {            
                                               
                    Offer__Share ostmp1 = (Offer__Share)RecordSharingUtilityClass.CreateShareRecordSingle(o.Id, offerCountry.get(o.Id).Application__r.Job__r.Country__r.Country_Director__c, 'Offer__Share', 'read', Schema.Offer__Share.RowCause.Custom_Apex_Sharing_Rule__c);
                    offerShares.add(ostmp1);
                    Offer__Share ostmp2 = (Offer__Share)RecordSharingUtilityClass.CreateShareRecordSingle(o.Id, offerCountry.get(o.Id).Application__r.Job__r.Country__r.Country_People_Manager__c, 'Offer__Share', 'edit', Schema.Offer__Share.RowCause.Custom_Apex_Sharing_Rule__c);
                    offerShares.add(ostmp2);    
                                 
                   //Narpavi-TPT-(18-Nov-2015)-(SS-4694129)-Code Streamlining
                   //To set the access for the hiring manager to offer record moved from the method 'offerHiringManagerShareOnInsert' to 'applyOfferCountrySharing' method                 
                   if(o.Help_Type__c == 'Employee Offer' || o.Help_Type__c=='Consultant Offer')
                   {
                      Offer__Share ostmp3 = (Offer__Share)RecordSharingUtilityClass.CreateShareRecordSingle(o.Id, offerCountry.get(o.Id).Application__r.Job__r.Hiring_Manager__c, 'Offer__Share', 'edit', Schema.Offer__Share.RowCause.Hiring_Manager_Access__c);
                      offerShares.add(ostmp3);
                   }   
                
                  }                                                     
                  if(offerShares!=null)                         
                  insert offerShares;                                                                                
             
              }                              
                //TPT-(25-Feb-2016)-Employee Offer and Onboarding Change
             if(trigger.isUpdate)
             {   
                List<Id> offerids=new List<Id> ();
                for(Offer__c ofr:scope)
                {
                    offerids.add(ofr.id);
                } 
               
               Map<Id,Offer__Share> MapofferShareRec= new Map<Id,Offer__Share>();
               
               List<Offer__Share> lstoffershare = [select id,RowCause,AccessLevel,ParentId from Offer__Share where ParentId IN:offerids AND RowCause = :Schema.Offer__Share.RowCause.Hiring_Manager_Access__c];                                           
               for(Offer__Share share:lstoffershare )
               {
                   MapofferShareRec.put(share.ParentId,share);
               }
               
               for(Offer__c o : scope)
               {      
                  if(o.Help_Type__c == 'Employee Offer'&& o.Hiring_Manager__c!= o.People_Group_Manager__c)
                  {                                                                                  
                       Offer__Share newoffershare=MapofferShareRec.get(o.id); 
                                                                                                   
                       if(newoffershare!=null)
                       {                   
                           newoffershare.AccessLevel ='read';
                           offerShares.add(newoffershare);
                       }                                                             
                  }   
              } 
            
              if(offerShares.size()>0)           
                update offerShares;   
            }  
          }                                                                                                    
           catch(DmlException e) {
                if(string.valueOf(e).contains('INACTIVE_OWNER_OR_USER')){
                    trigger.new[0].addError('Error: The job country people manager is inactive, please update the country record');
                } else {
                    trigger.new[0].addError(e);
                }
            } 
          }      
     
    
   public void OfferCommunityShare(){
    
        List<Offer__c> scope = trigger.new;
    
        //map to store applicants as key and related offeres to them as values
        Map<Id,List<Id>> mapApplicantToOffer=new Map<Id,List<Id>>();
        //set to store offer ids for which access need to be removed
        Set<Id>setOfferIds=new Set<id>();
        for(Offer__c  off: scope){
            Offer__c oldRecord=(Offer__c)trigger.oldMap.get(off.id);
            Offer__c newRecord=(Offer__c)trigger.newMap.get(off.id);
            if(oldRecord.Make_Visible_To_Candidate__c!=newRecord.Make_Visible_To_Candidate__c){
                if(off.Applicant__c!=null){
                    if(newRecord.Make_Visible_To_Candidate__c==true){
                        off.Candidate_With_Access_To_Record__c=off.Applicant__c;
                        if(!mapApplicantToOffer.containskey(off.Applicant__c)){
                            mapApplicantToOffer.put(off.Applicant__c,new List<Id>());
                        }
                        mapApplicantToOffer.get(off.Applicant__c).add(off.id);
                    }else{
                        off.Candidate_With_Access_To_Record__c=null;
                        setOfferIds.add(off.id);
                    }
                }
            }
        }
        
        system.debug('***********mapApplicantToOffer'+mapApplicantToOffer);
        system.debug('***********setOfferIds'+setOfferIds);
        
        //removing access to offeres records
        //fetch old share records for offer and delete them
        if(setOfferIds.size()>0){
            List<Offer__Share> oldOfferShrs = [SELECT Id FROM Offer__Share WHERE ParentId IN :setOfferIds AND RowCause = :Schema.Offer__Share.rowCause.Candidate__c];
            if(oldOfferShrs.size()>0){
                delete oldOfferShrs;
            }
        }
        
        //Assigning access to offer records
        if(mapApplicantToOffer.size()>0){
            //map to store the users and related offers which needs to be shared
            Map<Id,List<Id>> mapUserToOffer=new Map<Id,List<Id>>();
            for(Contact con:[select id,name,Related_Employee__c,Related_Employee__r.Profile.UserLicense.Name from Contact where Id IN: mapApplicantToOffer.keyset() AND Related_Employee__c!=null]){
                //check if related user is not Customer Community user,then share offer record with them
                if(!con.Related_Employee__r.Profile.UserLicense.Name.equalsignorecase('Customer Community')){
                    if(!mapUserToOffer.containskey(con.Related_Employee__c)){
                        mapUserToOffer.put(con.Related_Employee__c,new List<Id>());
                    }
                    mapUserToOffer.get(con.Related_Employee__c).addAll(mapApplicantToOffer.get(con.id));
                }
            }
            
            if(mapUserToOffer.size()>0){
                List<sobject> listRecShrs  = new List<sobject>();
                //creating job__share records with help of RecordSharingUtilityClass
                For(Id Userid:mapUserToOffer.keyset()){
                    listRecShrs.addAll(RecordSharingUtilityClass.CreateShareRecord(mapUserToOffer.get(Userid),Userid,'Offer__Share','Edit'));
                }
                if(listRecShrs.size()>0){
                    //assign sharing reason to records
                    for(sobject sobj:listRecShrs){
                        sobj.put('RowCause',Schema.Offer__Share.RowCause.Candidate__c);
                    }
                    // Insert sharing records and capture save result 
                    // The false parameter allows for partial processing if multiple records are passed  into the operation 
                    Database.SaveResult[] lsr = Database.insert(listRecShrs,false);
                    // Create counter
                    Integer i=0;
            
                    // Process the save results
                    for(Database.SaveResult sr : lsr){
                        if(!sr.isSuccess()){
                            // Get the first save result error
                            Database.Error err = sr.getErrors()[0];
                    
                            // Check if the error is related to a trivial access level
                            // Access levels equal or more permissive than the object's default 
                            // access level are not allowed. 
                            // These sharing records are not required and thus an insert exception is 
                            // acceptable. 
                            system.debug('*******error:'+err);
                            if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&  err.getMessage().contains('AccessLevel'))){
                                // Throw an error when the error is not related to trivial access level.
                                system.debug('*******error:'+((Offer__Share)listRecShrs[i]).ParentId);
                                trigger.newMap.get(((Offer__Share)listRecShrs[i]).ParentId). addError( 'Unable to grant sharing access due to following exception: ' + err.getMessage());
                            }
                        }
                        i++;
                    }
                }
            }
        }       
   } 
   
    //Narpavi-TPT-(18-Nov-2015)-(SS-4694129)-Commented the below method for streamlining the code
  //To set access for Hiring Manger to application record is moved to the method 'applyOfferCountrySharing'
  /* //TPT : Onboarding Sprint-1 - Offer requirement (May2014)
   //Method to set Read/Write access for Hiring manager sharing settings
   public void offerHiringManagerShareOnInsert()
   {
      List<Offer__Share> offerShareList=new List<Offer__Share>();
      Offer__Share rShare;
      for(Offer__c offers:[SELECT id,name,Application__r.Job__r.Hiring_Manager__r.id,RecordType.DeveloperName FROM Offer__c WHERE id IN:trigger.new])
      {
         rShare= new Offer__Share();
         if(offers.Application__r.Job__r.Hiring_Manager__r.id!=null)
         {
           if(offers.RecordType.DeveloperName=='Consultant_Offer' || 
              offers.RecordType.DeveloperName=='Employee_Offer')
           {
              rShare.ParentId=offers.id;
              rShare.UserOrGroupId=offers.Application__r.Job__r.Hiring_Manager__r.id;
              rShare.AccessLevel='Edit';
              rShare.RowCause=Schema.Offer__Share.RowCause.Hiring_Manager_Access__c;
              offerShareList.add(rShare);
           }         
         }      
      }   
      if(offerShareList.Size()>0)
      {
         Database.SaveResult[] lsr = Database.insert(offerShareList,false);
         Integer i=0;
         for(Database.SaveResult sr : lsr)
         {
            if(!sr.isSuccess())
            {
               Database.Error err = sr.getErrors()[0];
               if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION 
                   && err.getMessage().contains('AccessLevel')))
                   {                       
                      trigger.newMap.get(offerShareList[i].ParentId). addError( 'Unable to grant sharing access due to following exception: ' + err.getMessage());
                   }
            }
            i++;
         }         
      }      
   } */
      
    //TPT : Onboarding Sprint-1 - Offer requirement (May2014)
    //Update application status based on offer status and offer response
    //TPT- Poornima - modified method for Employee O&O changes
    //Removed code related to "verbal offer response" & offer status "verbal offer declined" as this section is removed from offer
    //Removed code related to "Unconditional offer response" as unconditional offer section is removed
    //Narpavi-TPT-(18-Nov-2015)-(SS-4694129)-code streamlining
    //Compare old and new value and then set the field
    //TPT(Poornima)- Amended -Code refactoring work - 6/Apr/2016  
    public void updateApplicationStatus()
    {
        List<Offer__c> scope= trigger.new;
        List<Id> applicationIds=new List<Id>();
        for(Offer__c O:scope)
        {
            applicationIds.add(O.Application__c);
        }
        Map<Id,Application__c> applicationMap = new Map<Id,Application__c>([SELECT id,Help_Offer_Status__c,Help_Offer__c,Status__c from Application__c where id in:applicationIds]);
        Map<Id,Application__c> applicationsToUpdate=new Map<Id,Application__c>();
        for(Offer__c offer:scope )
        { 
            Application__c application=applicationMap.get(offer.Application__c);
            if(application!=null)
            {
                 Application__c updateApp=new Application__c();
                 updateApp.Id=application.Id;
                 
                 //TPT-Narpavi-SCS-2136-(4/3/15) 
                 //Populating help field from Offer for validation rule in Onboarding
                 boolean recordToUpdate=false;
                 if(Trigger.isInsert)
                 {       
                     updateApp.Help_Offer__c= offer.id; 
                     recordToUpdate=true;
                 }
                 if(trigger.old !=null)
                 {
                     Offer__c oldOfferRecord=(Offer__c)trigger.oldMap.get(offer.id);
                     Offer__c newOfferRecord=(Offer__c)trigger.newMap.get(offer.id);               
                                                      
                    //TPT-Narpavi-Recurit Phase 2-7/9/2015
                    //populate the help field from offer to application for validation rule in onboarding            
                    if(oldOfferRecord!=null && oldOfferRecord.Offer_Status__c!=newOfferRecord.Offer_Status__c)
                    {                  
                        updateApp.Help_Offer_Status__c=offer.Offer_Status__c;    
                        recordToUpdate=true;             
                    }                 
                    if ((offer.Offer_Status__c!='Offer Withdrawn By VSO')&&(offer.Offer_Status__c!='Withdrawn (Candidate Requested)'))   
                    {  
                        //Application status change on conditional offer response                        
                        if(offer.Conditional_Offer_Response__c=='Accepted') 
                        {                         
                             //Dinesh-TPT- Fix for SS-4336583 -29/Sep/2015.
                            //Compare the old and new value then set the field value.                     
                              if(oldOfferRecord!=null && oldOfferRecord.Conditional_Offer_Response__c!=newOfferRecord.Conditional_Offer_Response__c)
                              {            
                                  updateApp.Status__c='Onboarding in Progress';
                                  isApplicationValid=true;
                              }
                        }                           
                        else if(offer.Conditional_Offer_Response__c=='Declined')
                        {                   
                            if(oldOfferRecord!=null && oldOfferRecord.Conditional_Offer_Response__c!=newOfferRecord.Conditional_Offer_Response__c)
                        { 
                          updateApp.Status__c ='Offer Declined';
                          recordToUpdate=true;
                        }  
                    }           
                           
                    //Application status change on unconditional offer date                 
                    if((offer.Help_Type__c=='Employee Offer'||offer.Help_Type__c=='Consultant Offer')
                    &&(offer.Unconditional_Offer_Date__c!=null))
                    {                    
                      if(oldOfferRecord!=null && oldOfferRecord.Unconditional_Offer_Date__c!=newOfferRecord.Unconditional_Offer_Date__c)
                      {
                          updateApp.Status__c='Unconditional Offer';
                          recordToUpdate=true;
                       } 
                    }
                }
                else if(offer.Offer_Status__c=='Offer Withdrawn By VSO' && !test.isRunningTest())
                {                 
                   if(oldOfferRecord!=null && oldOfferRecord.Offer_Status__c!=newOfferRecord.Offer_Status__c)
                   {
                      updateApp.Status__c='Offer Withdrawn by VSO';
                      recordToUpdate=true;
                   }
                } 
             }                        
             if(recordToUpdate)
             applicationsToUpdate.put(updateApp.Id,updateApp);
             }           
        }
        try
        { 
              if(applicationsToUpdate.size()>0)           
                  update applicationsToUpdate.values();           
        }
        catch (DMLException e) 
        {
            string errMsg=string.valueOf(e);
            string ValidationMessage;
            if(errMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) 
            {
               ValidationMessage = errMsg.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
               trigger.new[0].addError(ValidationMessage);     
            }
              else
              trigger.new[0].addError(e);  
        }         
    }   
      
   //Narpavi-TPT-(18-Nov-2015)-(SS-4694129)-code streamlining
   //Compare old and new value and then set the field 
   //TPT(Poornima)- Amended -Code refactoring work - 6/Apr/2016 
   public void updateOfferFieldsInOnBoarding()
   {      
       List<Offer__c> scope =Trigger.new;
       
       List<Id> applicationIds =new List<Id>();
       for(Offer__c o:scope)
       {
           applicationIds.add(o.Application__c);
       }       
       List<OnBoardingCheck__c> lstToUpdate=new List<OnBoardingCheck__c>();
       Map<id,OnBoardingCheck__c> onboardMap=new Map<id,OnBoardingCheck__c>();
       List<OnBoardingCheck__c> lstonboard=[SELECT id,RecordType.DeveloperName,Proposed_Start_Date__c,Application__r.id,Proposed_End_Date__c,Send_Medical_Request_Email__c,Medical_Clearance_Progress__c,createddate FROM OnBoardingCheck__c WHERE Application__r.id in:applicationIds ORDER BY createddate asc];
       for(OnBoardingCheck__c onb:lstonboard)
       {
         onboardMap.put(onb.Application__r.id,onb); 
       }
       for(Offer__c offer:scope)
       { 
          Offer__c oldOffer=(Offer__c)trigger.oldMap.get(offer.id);
          Offer__c newOffer=(Offer__c)trigger.newMap.get(offer.id); 
          boolean RecordToUpdate=false;   
          
          OnBoardingCheck__c obc=onboardMap.get(offer.Application__c);
          if(obc!=null)
          {
              OnBoardingCheck__c onboardUpdate=new OnBoardingCheck__c();
              onboardUpdate.Id=obc.Id;          
                                  
              if(newOffer.Proposed_Start_Date__c!=oldOffer.Proposed_Start_Date__c)
              {
                  onboardUpdate.Proposed_Start_Date__c=offer.Proposed_Start_Date__c;
                  RecordToUpdate=true;
              }                     
              if(newOffer.Proposed_End_Date__c!=oldOffer.Proposed_End_Date__c)
              {
                  onboardUpdate.Proposed_End_Date__c=offer.Proposed_End_Date__c;
                  RecordToUpdate=true; 
              }          
              //TPT-Narpavi-Recurit Phase 2-7/9/2015
              //populate the No Medical Email field from offer to onboarding
              if(obc.RecordType.DeveloperName == 'Volunteer')
               {                  
                   if(newOffer.No_Medical_Email__c!=oldOffer.No_Medical_Email__c)
                  {                  
                      onboardUpdate.No_Medical_Email__c=offer.No_Medical_Email__c;
                      RecordToUpdate=true;   
                   }
                } 
                  
                //Narpavi-TPT-SS-4730394-(7-Oct-2015)
                //Issue-Medical Clearance Progress field value change from Completed to Awaiting Volunteer Response
                //Compare old and new value and then set the field            
                if(newOffer.Medical_Request_Email_Sent__c!=oldOffer.Medical_Request_Email_Sent__c)                   
                {            
                    if(obc.RecordType.DeveloperName == 'Volunteer' && offer.Medical_Request_Email_Sent__c==True)
                    {
                        onboardUpdate.Send_Medical_Request_Email__c = True;
                        onboardUpdate.Medical_Clearance_Progress__c = 'Awaiting Volunteer Response';
                        RecordToUpdate=true;
                    }              
                } 
               if(RecordToUpdate)
                lstToUpdate.add(onboardUpdate);
            }
        }      
      if(lstToUpdate.size()>0)
           update lstToUpdate; 
    }
    
   //TPT-Narpavi-SCS-1122-(4/9/2015)
   //populate the probation period in offer object from pay band object
   //TPT(Poornima)- Amended -Code refactoring work - 6/Apr/2016
   public void updateOfferFields()
   {
       List<Offer__c> scope=Trigger.new;
       
       List<Id> payBandIds=new List<Id>();
       List<Id> applicationIds=new List<Id>();
       for(Offer__c O:scope)
       { 
           payBandIds.add(O.Pay_Band__c);
           applicationIds.add(O.Application__c);
       }       
       
       List<Offer__c> offerRecordToUpdate=new list<Offer__c> ();  
       Map<id,fHCM2__Salary_Band__c> paybandMap=new  Map<id,fHCM2__Salary_Band__c>( [select id,Probation_Period__c,Notice_Period_During_Probation__c,Notice_Period_After_Probation__c from fHCM2__Salary_Band__c where id in:payBandIds]);
       Map<id,Application__c> applicationMap=new Map<id,Application__c>([select id,Job__r.People_Group_Manager__c,Job__r.People_Group_Admin__c,Job__r.Hiring_Manager__c,Job__r.Contract_Type__c from Application__c where id in:applicationIds]);
       
       for(Offer__c offer:scope)
       {
           fHCM2__Salary_Band__c payb=paybandMap.get(offer.Pay_Band__c);
           Application__c app=applicationMap.get(offer.Application__c);     
           Offer__c ofr=new Offer__c();
           ofr.Id=offer.Id;
         
         //Poornima-TPT-Employee Offer and onBoarding
         //Update the fields from job record to offer record.       
        if(app!=null && offer.Help_Type__c=='Employee Offer')         
        {                                
                  ofr.People_Group_Manager__c=app.Job__r.People_Group_Manager__c;
                  ofr.People_Group_Admin__c=app.Job__r.People_Group_Admin__c;
                  ofr.Hiring_Manager__c=app.Job__r.Hiring_Manager__c;
                  ofr.VSO_Offer_Contact_Person__c=app.Job__r.People_Group_Admin__c;    
                  
               //TPT-(1-March-2015)-SCR-3:populate the probation and notice period in offer for fixed term contract employee
                if(app.Job__r.Contract_Type__c=='Fixed Term')
                {
                    if(offer.Help_Short_Fixed_Term_3__c)
                    {
                        ofr.Probation_Period__c= '1 month'; 
                        ofr.Notice_Period_During_Probation__c='1 week';
                        ofr.Notice_Period_After_Probation__c='2 weeks';
                    }
                    else if(offer.Help_Short_Fixed_Term_6__c)
                    {
                        ofr.Probation_Period__c= '3 months'; 
                        ofr.Notice_Period_During_Probation__c='1 week';
                        ofr.Notice_Period_After_Probation__c='1 month';               
                    }
               }                                 
                                  
            if(payb!=null && app.Job__r.Contract_Type__c!='Short Term Agency Work'&&
                (!offer.Help_Short_Fixed_Term_6__c)&& (!offer.Help_Short_Fixed_Term_3__c))
            {              
                if(payb.Probation_Period__c!=null )
                {                   
                    ofr.Probation_Period__c=payb.Probation_Period__c; 
                    ofr.Notice_Period_During_Probation__c=payb.Notice_Period_During_Probation__c;
                    ofr.Notice_Period_After_Probation__c=payb.Notice_Period_After_Probation__c;                  
                } 
            }    
          }
                                   
            offerRecordToUpdate.add(ofr);             
         }                
         if(offerRecordToUpdate.size()>0)
         update offerRecordToUpdate;
        }
       
            
    public static OfferTriggerHandler getHandler(){
        if(handler == null){
            handler = new OfferTriggerHandler();
        }
    return handler;
    }
    
    private static OfferTriggerHandler handler;
    
    private static boolean trueFirstTimeOnly = true;
    
    // static function will only return true once in each transaction
    // used to avoid trigger recursion
    // see http://help.salesforce.com/apex/HTViewSolution?id=000133752&language=en_US
    public static boolean runOnce(){
        if(trueFirstTimeOnly){
            trueFirstTimeOnly = false; 
            return true;
        }else{
            return false;
        }
    }
    
    // for testing
    public static void ClearRunOnce()
    {
        trueFirstTimeOnly = true;
    }
     
}