trigger UpdateEmploymentRecord on fHCM2__Employment__c (after update,after insert) 
{
     if (EmploymentrecordTrigger.runOnce()) 
     {
     for (fHCM2__Employment__c er: Trigger.new)
         {
            EmploymentrecordTrigger.getHandler().execute();
         }
    }


}