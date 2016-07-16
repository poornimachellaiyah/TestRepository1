/*Dinesh-TPT-Recruit Phase-2 changes-06/July/2015
 class created to get the information about the Task in Activity History section.*/
 
public without sharing class TaskTriggerHandler { 

    private TaskTriggerHandler()
    {
        if(!trigger.isExecuting)
        { 
            throw new InternalException('Not in Trigger context!'); 
        }
    }
    
    public void execute() 
    {
         if(Trigger.isAfter)
         {
            if (Trigger.isInsert)             
                updateOfferFields();                 
         }     
    }
    
    //Dinesh-TPT-Recruit Phase-2 changes-06/July/2015.
    //Method to update 'Conditional Offer Date' field in offer object
    public void updateOfferFields()
    {
         List<Task> lstTask=[SELECT id, WhatId, Subject, ActivityDate FROM task WHERE id IN:trigger.new AND Subject=:'Email: VSO Conditional Offer'];
         List<Id> offerIds=new List<Id>();
         List<Offer__c> lstToUpdate=new List<Offer__c>();
         for(Task t:lstTask)
         {
             offerIds.add(t.WhatId);
         }        
         Map<Id,Offer__c> offerMap=new Map<Id,Offer__c>([SELECT id,RecordType.DeveloperName FROM Offer__c WHERE id IN:offerIds]);
         try
         {
             for(Task tsk:lstTask)
             {
                 Offer__c ofr=offerMap.get(tsk.WhatId);
                 if(ofr!=null)
                 {
                     //TPT-Poornima - Added employee offer in the condition for Emp O&O changes - dated 17/11/2015
                     if(ofr.RecordType.DeveloperName=='Volunteer_Offer' || ofr.RecordType.DeveloperName=='Employee_Offer' )
                     {   
                         Offer__c offer=new Offer__c();
                         offer.id=ofr.Id;
                         offer.Conditional_Offer_Date__c=tsk.ActivityDate;
                         lstToUpdate.add(offer);                          
                     }	
                 }
         	 }
             if(lstToUpdate.size()>0)
                 update lstToUpdate;
         }
         catch(Exception ex)
         {
            System.debug('Exception in TaskTriggerHandler'+ex.getMessage());
         }
        
    }
    
    
    public static TaskTriggerHandler getHandler(){
            if(handler == null){
                handler = new TaskTriggerHandler();
            }
            return handler;
     }
    
    private static TaskTriggerHandler handler;
}