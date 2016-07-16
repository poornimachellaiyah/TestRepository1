/*
******************************************************************   
 Change log:Code Streamlining. Search Tag : TPT-(30-Nov-2015)
 
   Modified date:6 Apr 2016
   Modified by: Poornima-TPT
   Purpose:Code Refactoring (Code bulkification)
   Search Tag : refactoring
                        
****************************************************************** 
*/ 

public without sharing class PersonalHealthInformationTriggerHandler 
{

    public boolean isValid;
    private static PersonalHealthInformationTriggerHandler handler;
    
    private PersonalHealthInformationTriggerHandler()
    {
        isValid=false;
        if(!trigger.isExecuting){
            throw new InternalException('Not in Trigger context!');
        }
    }
    
    public static PersonalHealthInformationTriggerHandler getHandler()
    {
        if(handler == null)
        {
            handler = new PersonalHealthInformationTriggerHandler();
        }
    return handler;
    }
    
     public void execute()
     {
        if(trigger.isAfter)
        {
            if(trigger.isUpdate)
            {
                this.updateOnboardingFields();
            }
        }
    }
    
  //Narpavi-TPT-(30-Nov-2015)-(SS-4694129)-Code Streamlining
  //Streamline the select statement
  //Poornima - TPT - 06-apr-2016 - Code refactoring work - bulkified code
  public void updateOnboardingFields()
  {
      List<Personal_Health_Information__c> newHealthInfo= trigger.new;    //TPT-(30-Nov-2015)
      List<Id> appIds=new List<Id>();
      for(Personal_Health_Information__c ph:newHealthInfo)
      {
         appIds.add(ph.ApplicationID__c); 
      }
      List<OnBoardingCheck__c> lstToUpdate=new List<OnBoardingCheck__c>();
      Map<Id,OnBoardingCheck__c> onboardMap=new  Map<Id,OnBoardingCheck__c>();            
      List<OnBoardingCheck__c > onboard=[SELECT id,Medical_Clearance_Progress__c,CreatedDate,Application__c,Application__r.id FROM OnBoardingCheck__c WHERE Application__r.id=:appIds order by CreatedDate asc];
      for(OnBoardingCheck__c  obc:onboard)
      {onboardMap.put(obc.Application__c,obc);
      }
      
     for(Personal_Health_Information__c HealthInfo:newHealthInfo)
     {
         OnBoardingCheck__c onb= onboardMap.get(HealthInfo.ApplicationID__c);
         if(onb!=null)
         {
             if(HealthInfo.Medical_Form_Uploaded__c)
             {                     
                 onb.Medical_Clearance_Progress__c = 'Forms Submitted';
             }
             lstToUpdate.add(onb);
         }                          
     }
     if(lstToUpdate.size()>0)             
         update lstToUpdate;  
             
    
  }    

}