public with sharing class POSIntegrationService {

    // Fetch Orders from MockAPI and insert into Salesforce Sale_Order__c
    public static void fetchAndInsertOrders() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        // Use Named Credential (base URL)
        req.setEndpoint('callout:POS_API_NC/orders');
        req.setMethod('GET');
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            List<Object> orders = (List<Object>) JSON.deserializeUntyped(res.getBody());
            List<Sale_Order__c> salesOrders = new List<Sale_Order__c>();

            for (Object o : orders) {
                Map<String, Object> order = (Map<String, Object>) o;

                Sale_Order__c so = new Sale_Order__c();
                so.Order_Number__c = (String) order.get('orderNumber');
                so.Total_Amount__c = order.containsKey('totalAmount') ? Decimal.valueOf(order.get('totalAmount').toString()) : 0;
                so.Status__c = (String) order.get('status');
                so.Customer__c = (String) order.get('customerId'); // assumes this is a lookup text Id or external id

                salesOrders.add(so);
            }
            if (!salesOrders.isEmpty()) {
                insert salesOrders;
                System.debug('Inserted ' + salesOrders.size() + ' Sale Orders from POS');
            }
        } else {
            System.debug('Error fetching orders: ' + res.getBody());
        }
    }

    // Create a new order in MockAPI (POST) when you create Sale_Order__c in Salesforce
    public static void sendOrderToPOS(Sale_Order__c so) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:POS_API_NC/orders');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> bodyMap = new Map<String, Object>{
            'orderNumber' => so.Order_Number__c,
            'customerId'  => so.Customer__c,
            'totalAmount' => so.Total_Amount__c,
            'status'      => so.Status__c
        };

        req.setBody(JSON.serialize(bodyMap));

        HttpResponse res = http.send(req);
        System.debug('POST response: ' + res.getBody());
    }
}
