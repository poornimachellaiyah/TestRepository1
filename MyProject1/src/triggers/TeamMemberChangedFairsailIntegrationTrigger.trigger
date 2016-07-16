trigger TeamMemberChangedFairsailIntegrationTrigger on fHCM2__Team_Member__c (after update) {
    if (FairsailIntegrationHandler.runOnce())
    {
        for (fHCM2__Team_Member__c tm: Trigger.new){
            if (tm.VSO_Recruit_Contact_Record__c != null)
                FairsailIntegrationHandler.getHandler().ProcessTeamMemberChanged(tm);
        }
    }
}