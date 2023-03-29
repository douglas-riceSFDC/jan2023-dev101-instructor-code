trigger Timesheet on Timesheet__c (before update, after insert, before insert) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        TimesheetRejectionIncrementor incrementor = new TimesheetRejectionIncrementor();
        incrementor.incrementRejectionNumber(Trigger.new, Trigger.oldMap);
    } else if(Trigger.isAfter && Trigger.isInsert) {
        TimesheetSubmissionTaskGenerator.generateSubmissionReminder(Trigger.new);
    } else if(Trigger.isBefore && Trigger.isInsert) {
        TimesheetValidator.validateTimesheetValues(Trigger.new);
    }
}