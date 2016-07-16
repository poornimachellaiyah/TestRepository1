/* * Created By: Dinesh -TPT
   * Project Name: AVI Job Integration
   * Created Date: (19-Apr-2016)
   * Description:
        1. Scheduler class to send the Applicant details to the AVI admin user as a batch
*/

global class ScheduledBatchAVIEmailAlerts implements Schedulable 
{  
  global void execute(SchedulableContext sc)
   {
        SendApplicantDetailsToAVI ea=new SendApplicantDetailsToAVI ();
        Database.executeBatch(ea,10);    
   }

}