@RestResource(urlMapping='/Inventory__c/*')
global without sharing class B2BInventory {

    @HttpGet
        global static Inventory__c getInventoryBySKU() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String productId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        Inventory__c inventory=[SELECT Id,Status__c,Available_quantity__c ,Reserved_quantity__c 
                                from Inventory__c 
                                where Product__c=:productId
                                ];

        return inventory;
    }

    @HttpPatch
        global static void updateReservedQty() {
        RestRequest request = RestContext.request;
        String productId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        Inventory__c inventory = [SELECT Id,Reserved_quantity__c,comitted_quantity__c 
                                from Inventory__c 
                                where 
                                RProduct__r.StockKeepingUnit=:productId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value

        for(String fieldName : params.keySet()) {

            inventory.put(fieldName, params.get(fieldName));
        }
        try{
            update inventory;
           }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }    


}