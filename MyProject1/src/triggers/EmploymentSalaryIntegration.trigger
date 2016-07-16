trigger EmploymentSalaryIntegration on fHCM2__Employment__c (after insert,after update) 
{
    
        for (fHCM2__Employment__c  er: Trigger.new)
        {
            if(er.fHCM2__Basis__c=='Employee')
            {         
               //if ( SalaryIntegrationHandler.runOnce()) 
               //{            
                 SalaryIntegrationHandler.gethandler().execute();           
               //}
            }
        }    
   
}