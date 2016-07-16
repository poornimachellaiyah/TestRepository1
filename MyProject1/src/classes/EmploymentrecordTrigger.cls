/*
******************************************************************   
 Change log:Code Streamlining. Search Tag : TPT-(30-Nov-2015)
            TriggerTidying - Ian Finch Mar 2015          
****************************************************************** 
*/ 

public without sharing class EmploymentrecordTrigger
{

   private EmploymentrecordTrigger(){
        if(!trigger.isExecuting){
            throw new InternalException('Not in Trigger context!');
        }
    }
    
     public static EmploymentrecordTrigger getHandler(){
        if(handler == null){
            handler = new EmploymentrecordTrigger();
        }
        return handler;
    }
    
    private static EmploymentrecordTrigger handler;
    
    
     public void execute(){
        if(trigger.isAfter){
            if(trigger.isInsert)
            {
                            
            }
            else if(trigger.isUpdate)
            {
                updateSalaryfields();
                     
            }   
            if(trigger.isInsert || trigger.isUpdate)              
            {
                 updateEmploymentRecord(); 
            }
        }
        if(trigger.isBefore)
        {
            if(trigger.isUpdate)
            {              
                                              
            }
        }
    }

   //TPT-update the payroll ID from team member in Employment record
   //Narpavi-TPT--(30-Nov-2015)-(SS-4694129)-Code Streamlining   
   //Streamline the select statement    
   // TriggerTidying - Ian Finch 09/Mar/2016 - adjusted to process batches properly. Only changes Employment record if needed
  public void updateEmploymentRecord()
  {
     
    list<fHCM2__Employment__c> scope=trigger.new;       //TPT-(30-Nov-2015)
    list<fHCM2__Employment__c> empRecordToUpdate=new list<fHCM2__Employment__c> ();
     
    // fetch all related team members in one go and store them in a map 
    List<Id> teamMemberIds = new List<Id>();
    for(fHCM2__Employment__c e:scope)
    {
        teamMemberIds.add(e.fHCM2__Team_Member__c);
    }
    Map<Id,fHCM2__Team_Member__c> teamMemberMap = new Map<Id,fHCM2__Team_Member__c>( 
             [SELECT id,fHCM2__Current_Employment__r.Senior_Approver_for_Budget__r.Name,
                 fHCM2__Current_Employment__r.Manager_Employment__r.fHCM2__Email__c,Payroll_ID_Formula__c,
                 fHCM2__Department__r.fHCM2__Policy__r.fHCM2__Hours_Per_Week__c 
                 FROM fHCM2__Team_Member__c Where id= :teamMemberIds]);
       
    // loop through all the employment records in the batch      
    for(fHCM2__Employment__c e:scope)
    {
        // get related team member if it exists
        fHCM2__Team_Member__c tm = teamMemberMap.get(e.fHCM2__Team_Member__c);
        if (tm != null)
        {
            // updEmp will be used to apply updates to existing records if needed
            fHCM2__Employment__c updEmp=new fHCM2__Employment__c();  
            updEmp.Id = e.Id;
            
            boolean recordToUpdate = false;   
            if(e.fHCM2__Basis__c=='Volunteer')               
            {  
                // only change field if it needs to change
                if (!StringsSame(e.Payroll_ID__c,tm.Payroll_ID_Formula__c))
                {
                    updEmp.Payroll_ID__c=tm.Payroll_ID_Formula__c;  
                    recordToUpdate = true;             
                }
            }                            
            //Poornima-TPT-Salary Changes-(13/3/15)
            //Populating help field with hours_per_week in policy, for the validation rule.      
            // only change field if it needs to change
            if (!NumbersSame(e.Help_Hours_Per_Week_In_Policy__c, tm.fHCM2__Department__r.fHCM2__Policy__r.fHCM2__Hours_Per_Week__c))
            {
                updEmp.Help_Hours_Per_Week_In_Policy__c=tm.fHCM2__Department__r.fHCM2__Policy__r.fHCM2__Hours_Per_Week__c;    
                recordToUpdate = true;
            }
                       
            //Narpavi-TPT-Salary Changes-(20/3/15)
            //Populating help field with team member email id for emailalert                                          
            if (!StringsSame(e.Help_Manager_Email__c, tm.fHCM2__Current_Employment__r.Manager_Employment__r.fHCM2__Email__c))
            {
                updEmp.Help_Manager_Email__c=tm.fHCM2__Current_Employment__r.Manager_Employment__r.fHCM2__Email__c;
                recordToUpdate = true;
            }
                              
                                    
            //Narpavi-TPT-Salary Changes-(20/4/15)
            //Populating help field with senior approver for budget from employment for the payflow service.                       
            if (!StringsSame(e.Help_Senior_Budget_Approver_Name__c, tm.fHCM2__Current_Employment__r.Senior_Approver_for_Budget__r.Name))
            {
                updEmp.Help_Senior_Budget_Approver_Name__c=tm.fHCM2__Current_Employment__r.Senior_Approver_for_Budget__r.Name;
                recordToUpdate = true;
            }
               
            // only add the updated records to batch if changes have been made   
            if (recordToUpdate)
                empRecordToUpdate.add(updEmp);
        }                                                 
    }             
    
    try
    {                        
        if(empRecordToUpdate.size()>0)
            update empRecordToUpdate;
    }
    // not sure why this is here
    catch (DMLException e) 
    {
        string errMsg=string.valueOf(e);
        string ValidationMessage;
        // todo: errors should attach to appropriate record, not always 0
        if(errMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) 
        {
          ValidationMessage = errMsg.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
          trigger.new[0].addError(ValidationMessage);     
        }
        else
        trigger.new[0].addError(e);   
  
    }
  } 
  
  // returns true if the strings are the same, including when they are both null
  private boolean StringsSame(String s1, String s2)
  {
      if (s1 == null && s2 == null)
          return true;
      if (s1 == null && s2 != null)
          return false;
      if (s1 != null && s2 == null)
          return false;
      
      return s1.equals(s2);
      
  }
  
  // returns true when numbers are the same, including when both null
  private boolean NumbersSame(decimal s1, decimal s2)
  {
      if (s1 == null && s2 == null)
          return true;
      if (s1 == null && s2 != null)
          return false;
      if (s1 != null && s2 == null)
          return false;
      
      return s1 == s2;
      
  }
  
   ///Narpavi-TPT-Salary Changes-(16/3/15)
  //Update Salary fields based on FTE change in Employment record
  //Narpavi-TPT-(30-Nov-2015)-(SS-4694129)-Code Streamlining
  //Streamline the select statement and compare the old and new value to set the field   
  // TriggerTidying - Ian Finch 09/Mar/2016 - adjusted to process batches properly. Only changes Employment record if needed  
  public void updateSalaryfields()
  {          
      List<fHCM2__Employment__c> scope=trigger.new;         //TPT-(30-Nov-2015)
      List<fHCM2__Salary__c> salRecordToUpdate= new List<fHCM2__Salary__c>();
                       
  
      // we want to get the current salary records for each employment record in the batch.
      // get them all in advance
      List<Id> currentSalaryIds = new List<Id>();
      for(fHCM2__Employment__c e:scope)
      {
          if (e.fHCM2__Current_Salary__c != null)
              currentSalaryIds.add(e.fHCM2__Current_Salary__c);
      }
      Map<Id,fHCM2__Salary__c> salaryMap = new Map<Id,fHCM2__Salary__c>(
              [SELECT id,Total_Cost_Excluding_In_Kind_Benefits__c,Country_Bonus__c,Social_Security_Component__c,
              Other_Statutory_Cont_Component__c,Basic_Annual_Salary__c,Help_Allowances__c,Basic__c,
              Basic_Salary_Dependents_Medical__c,fHCM2__Amount__c 
              FROM fHCM2__Salary__c WHERE id in :currentSalaryIds]);   
      
       
      // loop through all employment records in batch            
      for(fHCM2__Employment__c emp:scope) 
      {
          boolean recordToUpdate=false;    
          // only interested in ones with current salary
          if (emp.fHCM2__Current_Salary__c != null)
          {
              // find the matching current salary from map we made 
              fHCM2__Salary__c sal = salaryMap.get(emp.fHCM2__Current_Salary__c);
                                                       
              fHCM2__Employment__c oldEmpRecord=(fHCM2__Employment__c)trigger.oldMap.get(emp.id);
              fHCM2__Employment__c newEmpRecord=(fHCM2__Employment__c)trigger.newMap.get(emp.id);
                                
              if(emp.fHCM2__FTE__c != null&& sal.Basic_Annual_Salary__c !=null)  
              {                   
                  if(oldEmpRecord.fHCM2__FTE__c!= newEmpRecord.fHCM2__FTE__c)
                  {                                                   
                      sal.Basic__c= sal.Basic_Annual_Salary__c*emp.fHCM2__FTE__c;         
                      sal.Basic_Salary_Dependents_Medical__c=(sal.Basic_Annual_Salary__c+(sal.Basic_Annual_Salary__c*0.10))*emp.fHCM2__FTE__c ;                                              
                          
                      //todo: does  fHCM2__Amount__c only need to be set if Help_Allowances__c set?
                      if(sal.Help_Allowances__c !=null) 
                      {                        
                          sal.fHCM2__Amount__c=(sal.Basic_Annual_Salary__c+sal.Help_Allowances__c)*emp.fHCM2__FTE__c;                        
                      }
                      
                      if(sal.Annual_Gross_Salary__c!=null && sal.Social_Security_Component__c !=null 
                          && sal.Other_Statutory_Cont_Component__c !=null) 
                      {
                          sal.Total_Cost_Excluding_In_Kind_Benefits__c=(sal.Annual_Gross_Salary__c+sal.Social_Security_Component__c +sal.Other_Statutory_Cont_Component__c)*emp.fHCM2__FTE__c;                           
                      }
                      recordToUpdate=true; 
                  }
              }              
               
              //TPT-Narpavi-SCS-1246-(19/6/2015)
              //Populating help field in Salary record with the Employmnet Manager Email id for emailalert                              
              //TPT-(30-Nov-2015)-Changed the code assigning from Contact and below logic is replaced assigning email from User record                           
              if(emp.Manager_Employment__r.fHCM2__User__c !=null)
              {
                  if(oldEmpRecord.Manager_Employment__c!= newEmpRecord.Manager_Employment__c)
                  { 
                      if(emp.Manager_Employment__r.fHCM2__User__r.Email !=null)
                      {
                           sal.Helper_Line_Manager_Email__c=emp.Manager_Employment__r.fHCM2__User__r.Email; 
                           recordToUpdate=true;            
                      }  
                  }           
              }
                                 
              if(recordToUpdate)
                  salRecordToUpdate.add(sal);               
          }
      }
      // (end of employment loop)
      try
      {        
          if(salRecordToUpdate.size()>0)
              update salRecordToUpdate;          
      }  
      // not sure why this is here
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