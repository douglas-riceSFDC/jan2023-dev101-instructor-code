@isTest
private class TimesheetRejectionIncrementorTest {

    @TestSetup
    static void setUpTimesheets() {
        Account testAccount = createAccount('Test Account');
        Contact testContact = createContact(testAccount.Id, 'Smith');
        Timesheet__c testTimesheet = createTimesheet(testContact.Id, 'Draft');
    }

    private static Account createAccount(String name) {
        Account testAccount = new Account();
        testAccount.Name = name;

        insert testAccount;
        return testAccount;
    }


    private static Contact createContact(Id accountId, String name) {
        Contact employee = new Contact();
        employee.LastName = name;
        employee.AccountId = accountId;

        insert employee;
        return employee;
    }

    private static Timesheet__c createTimesheet(Id employeeId, String status) {
        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Employee__c = employeeId;
        testTimesheet.Status__c = status;
        testTimesheet.Week_Start_Date__c = Date.today();

        insert testTimesheet;
        return testTimesheet;
    }    

    @isTest
    static void incrementRejectionNumber_givenRejectedTimesheet_shouldIncrement() {
        Timesheet__c testTimesheet = [SELECT Status__c
                                        FROM Timesheet__c
                                        LIMIT 1];

        System.debug('^^^ ' + [SELECT Id, Name FROM Account]);

        Test.startTest();

        testTimesheet.Status__c = 'Rejected';
        update testTimesheet;

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [SELECT Number_of_Times_Rejected__c
                                                    FROM Timesheet__c
                                                    WHERE Id = :testTimesheet.Id
                                                    LIMIT 1];

        System.assertEquals(1, updatedTimesheets[0].Number_of_Times_Rejected__c, 
            'The number of times rejected should have incremented.');
    }

    @isTest
    static void incrementRejectionNumber_givenNonRejectedTimesheet_shouldNotIncrement() {
        Timesheet__c testTimesheet = [SELECT Status__c, Number_of_Times_Rejected__c
                                        FROM Timesheet__c
                                        LIMIT 1];

        Test.startTest();

        testTimesheet.Status__c = 'Approved';
        update testTimesheet;

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [SELECT Number_of_Times_Rejected__c
                                                    FROM Timesheet__c
                                                    WHERE Id = :testTimesheet.Id
                                                    LIMIT 1];

        System.assertEquals(testTimesheet.Number_of_Times_Rejected__c, 
            updatedTimesheets[0].Number_of_Times_Rejected__c, 
            'The number of times rejected should have stayed the same.');

    }

    @isTest
    static void incrementRejectionNumber_givenAlreadyRejectedTimesheet_shouldNotIncrementTwice() {
        Timesheet__c testTimesheet = [SELECT Status__c, Number_of_Times_Rejected__c
                                        FROM Timesheet__c
                                        LIMIT 1];

        testTimesheet.Status__c = 'Rejected';
        update testTimesheet;

        Test.startTest();

        testTimesheet.Hours__c = 40;
        update testTimesheet;

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [SELECT Number_of_Times_Rejected__c
                                                    FROM Timesheet__c
                                                    WHERE Id = :testTimesheet.Id
                                                    LIMIT 1];

        System.assertEquals(1, updatedTimesheets[0].Number_of_Times_Rejected__c, 
            'The number of times rejected should have only incremented once.');
    }
}