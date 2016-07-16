trigger EmploymentTrigger on fHCM2__Employment__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    EmploymentTriggerHandler.getHandler().execute();
}