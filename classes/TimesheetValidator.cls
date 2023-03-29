public with sharing class TimesheetValidator {
    
    public static void validateTimesheetValues(List<Timesheet__c> insertedTimesheets) {
        for(Timesheet__c t : insertedTimesheets) {
            t.addError('Please try again.');
        }
    }
}