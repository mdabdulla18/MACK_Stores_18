@isTest
private class ProductTriggerTest {
    @testSetup
    static void setupData() {
        // Create a dummy Sale Order (parent record)
        Sale_Order__c order = new Sale_Order__c();
        // Set other required fields for Sale_Order__c here if needed
        insert order;

        // Product with associated order line item
        Product__c p1 = new Product__c(
            Product_Name__c = 'Test Product With OLI',
            SKU_Code__c = 'SKU001',
            Price__c = 100
        );
        insert p1;

        // Order Line Item requires Sale_Order__c
        Order_Line_Items__c oli = new Order_Line_Items__c(
            Product__c = p1.Id,
            Sales_Order__c = order.Id // Required field added
        );
        insert oli;
    }

    static testMethod void testCannotDeleteProductWithOrderLineItems() {
        Product__c p = [SELECT Id FROM Product__c LIMIT 1];

        Test.startTest();
        try {
            delete p;
            System.assert(false, 'Delete should have been blocked.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot delete a product'), 'Expected addError message.');
        }
        Test.stopTest();
    }

    static testMethod void testCanDeleteProductWithoutOrderLineItems() {
        Product__c lonely = new Product__c(
            Product_Name__c = 'Lonely Product',
            SKU_Code__c = 'SKU002',
            Price__c = 50
        );
        insert lonely;

        Test.startTest();
        delete lonely;
        Test.stopTest();

        Integer cnt = [SELECT count() FROM Product__c WHERE Id = :lonely.Id];
        System.assertEquals(0, cnt, 'Product should have been deleted.');
    }
}