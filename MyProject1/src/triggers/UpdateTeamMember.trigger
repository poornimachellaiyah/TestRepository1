trigger UpdateTeamMember on fHCM2__Team_Member__c (after update,after insert) 
{
     if (TeamMemberTrigger.runOnce()) 
     {
         for (fHCM2__Team_Member__c tm: Trigger.new)
         {
              TeamMemberTrigger.getHandler().execute();
         }
     }

}