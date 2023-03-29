public with sharing class ProjectDuplicateChecker {
    
    @InvocableMethod(description='Returns duplicate projects' label='Duplicate Project Check' category='Project')
    public static List<ProjectDuplicateOutput> checkForDuplicateProjects(List<ProjectDuplicateInput> inputs) {
        Project__c currentProject = [SELECT Id, Name
                                                FROM Project__c
                                                WHERE Id = :inputs[0].projectId LIMIT 1];

        List<ProjectDuplicateOutput> returnedDuplicates = new List<ProjectDuplicateOutput>();
        List<Project__c> duplicateProjects = new List<Project__c>();

        duplicateProjects = [SELECT Id, Name
                                FROM Project__c
                                WHERE Name = :currentProject.Name
                                    AND Id != :currentProject.Id];
        
        ProjectDuplicateOutput output = new ProjectDuplicateOutput();
        output.duplicateProjects = duplicateProjects;
        returnedDuplicates.add(output);

        return returnedDuplicates;
    }

    public class OutCustomType {
        @InvocableVariable
        public List<Opportunity> opps;

        @InvocableVariable
        public List<Lead> lead;
    }

    public class ProjectDuplicateInput {
        @InvocableVariable
        public String projectName;

        @InvocableVariable
        public Id projectId;

        @InvocableVariable
        public Date projectDate;
    }

    public class ProjectDuplicateOutput {
        @InvocableVariable
        public List<Project__c> duplicateProjects;

        @InvocableVariable
        public String outputString;
    }
}