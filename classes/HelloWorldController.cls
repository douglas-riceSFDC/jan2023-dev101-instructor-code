public with sharing class HelloWorldController {

    private Timesheet__c timesheet;

    public HelloWorldController(ApexPages.StandardController controller) {
        timesheet = [SELECT Name
                        FROM Timesheet__c
                        WHERE Id = :controller.getId()];
    }

    public String getWelcomeMessage() {
        return 'Hello! Welcome! Here is your timesheet: ' + timesheet.Name;
    }
}