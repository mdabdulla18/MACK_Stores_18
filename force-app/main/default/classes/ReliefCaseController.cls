public with sharing class ReliefCaseController {
    @AuraEnabled
    public static Relief_Case__c createReliefCase(String name, String description, String contactEmail) {
        Relief_Case__c newCase = new Relief_Case__c();
        newCase.Name = name;
        newCase.Description__c = description;
        newCase.Contact_Email__c = contactEmail;
        insert newCase;
        return newCase;
    }
}