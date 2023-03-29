public with sharing class ApproveOrRejectTimesheetsController {

    @AuraEnabled(cacheable=true)
    public static List<Timesheet__c> getTimesheetsByProject(Id projectId) {
        try {
            System.debug('querying...');
            return [
                SELECT Id, Name, Hours__c, Employee__c, Status__c
                FROM Timesheet__c
                WHERE Project__c = :projectId
            ];
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void approveOrRejectTimesheets(List<Timesheet__c> timesheets, String status){
        try {
            for(Timesheet__c t: timesheets) {
                t.Status__c = status;
            }     

            update timesheets;
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void confirmTimesheets(List<Timesheet__c> timesheets) {
        try {
            upsert timesheets;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}