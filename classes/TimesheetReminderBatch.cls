public with sharing class TimesheetReminderBatch implements Database.Batchable<sObject>, Schedulable {
    
    public void execute(SchedulableContext context) {
        Database.executeBatch(new TimesheetReminderBatch(), 100);
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, Name, Week_Start_Date__c, Employee__c
                                            FROM Timesheet__c]);
    }

    public void execute(Database.BatchableContext context, List<Timesheet__c> scope) {
        for(Timesheet__c t : scope) {
            if(t.Week_Start_Date__c == null) {
                t.Week_Start_Date__c = Date.today();
            }
        }

        TimesheetSubmissionTaskGenerator.generateSubmissionReminder(scope);
    }

    public void finish(Database.BatchableContext context) {

    }
}