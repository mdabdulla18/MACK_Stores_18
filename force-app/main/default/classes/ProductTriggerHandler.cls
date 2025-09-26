public with sharing class ProductTriggerHandler {
    public void run() {
        if (Trigger.isBefore && Trigger.isDelete) {
            Set<Id> productIds = Trigger.oldMap.keySet();
            Map<Id, List<Order_Line_Items__c>> itemsByProduct =
                ProductService.getOrderLineItemsByProduct(productIds);

            for (Product__c p : (List<Product__c>) Trigger.old) {
                if (itemsByProduct.containsKey(p.Id) && !itemsByProduct.get(p.Id).isEmpty()) {
                    p.addError('Cannot delete a product with associated order line items.');
                }
            }
        }
    }
}