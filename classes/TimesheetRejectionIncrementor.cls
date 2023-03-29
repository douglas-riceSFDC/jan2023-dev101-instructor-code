public with sharing class TimesheetRejectionIncrementor {

    public void incrementRejectionNumber(List<Timesheet__c> updatedTimesheets,
                                            Map<Id, Timesheet__c> oldValueMap) {
        for(Timesheet__c t : updatedTimesheets) {
            if(t.Status__c == 'Rejected' 
                && oldValueMap.get(t.Id).Status__c != 'Rejected') {

                if(t.Number_of_Times_Rejected__c == null) {
                    t.Number_of_Times_Rejected__c = 0;
                }
                
                t.Number_of_Times_Rejected__c = t.Number_of_Times_Rejected__c + 1;
            }
        } 
    }
}