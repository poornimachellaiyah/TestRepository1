// Trigger disabled March 2016
// was not working properly and is apparently no longer needed - IDRF 24/Mar/2016

trigger UpdateSalaryRecord  on fHCM2__Salary__c (before insert) 
{
 for (fHCM2__Salary__c s: Trigger.new)
{
    // Ian note: fHCM2__Employment__r will not return anything here, so this will always be false
     if(s.fHCM2__Employment__r.fHCM2__Basis__c=='Employee')
    {
        if ( SalaryRecordTrigger.runOnce()) 
         {            
              SalaryRecordTrigger.gethandler().execute(); 
         }    
    }
    
}
}