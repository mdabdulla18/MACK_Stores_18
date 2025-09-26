public with sharing class ProductService {
    public static Map<Id, List<Order_Line_Items__c>> getOrderLineItemsByProduct(Set<Id> productIds) {
        Map<Id, List<Order_Line_Items__c>> result = new Map<Id, List<Order_Line_Items__c>>();
        if (productIds == null || productIds.isEmpty()) return result;

        for (Order_Line_Items__c oli : [
            SELECT Id, Product__c
            FROM Order_Line_Items__c
            WHERE Product__c IN :productIds
        ]) {
            if (!result.containsKey(oli.Product__c)) {
                result.put(oli.Product__c, new List<Order_Line_Items__c>());
            }
            result.get(oli.Product__c).add(oli);
        }
        return result;
    }
}