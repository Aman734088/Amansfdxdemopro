public without sharing class B2BInventoryResp{
    @AuraEnabled(cacheable=true)  
    public static void checkProductQuantity(String productId) {  
    Decimal res=0;   
    Http http = new Http();  
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://training2021org1--aman.sandbox.my.site.com/bikeonline/services/apexrest/Webservice/'+productId); 
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());  
        request.setMethod('GET');
    try 
    {  
        HttpResponse response = http.send(request);  
        System.debug(response);
        if (response.getStatusCode() == 200)  
            {  
                system.debug(JSON.deserializeUntyped(response.getBody()));
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                // res=(Decimal)results.get('Available_for_Purchase__c');  
                System.debug(results);    
            } 
    }
        catch (Exception e)
        { 
            System.debug(e.getMessage());
  
        }
}
     
@AuraEnabled 
    public static void updateReserveQuantity(String reservedQty,String productId){ 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://training2021org1--aman.sandbox.my.site.com/bikeonline/services/apexrest/Webservice/'+productId); 
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); 
        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
        request.setBody('{"Reserved__c":reservedQty}');

         HttpResponse response = http.send(request);
         // If the request is successful, parse the JSON response.
         system.debug(response);
    }  
    @AuraEnabled
        public static void updateCommittedQty(String committedQty,String productId){
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://training2021org1--aman.sandbox.my.site.com/bikeonline/services/apexrest/Webservice/'+productId);
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"Committed__c":committedQty}'); 
        HttpResponse response = http.send(request);
            system.debug(response);
     }
}