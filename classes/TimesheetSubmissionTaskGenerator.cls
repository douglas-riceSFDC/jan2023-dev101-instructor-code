public with sharing class TimesheetSubmissionTaskGenerator {
    
    public static void generateSubmissionReminder(List<Timesheet__c> insertedTimesheets) {
        List<Task> timesheetReminders = new List<Task>();

        for(Timesheet__c t : insertedTimesheets) {
            System.debug('Generating Task for ' + t.Name);

            Task reminder = new Task();
            reminder.Subject = 'Please submit your timesheet!';

            System.debug('Due Date : ' + t.Week_Start_Date__c.addDays(7));
            System.debug('Due Date : ' + t.Week_Start_Date__c + 7);

            reminder.ActivityDate = t.Week_Start_Date__c.addDays(7); // + 7
            reminder.WhoId = t.Employee__c;
            reminder.WhatId = t.Id;
            reminder.Priority = 'Normal';
            reminder.Status = 'Not Started';

            timesheetReminders.add(reminder);
        }

        System.debug('Inserting... ' + timesheetReminders);
        insert timesheetReminders;
    }
}