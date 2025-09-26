trigger ProductTrigger on Product__c (before delete) {
    new ProductTriggerHandler().run();
}