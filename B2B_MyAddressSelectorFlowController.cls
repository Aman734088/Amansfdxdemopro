public without sharing class B2B_MyAddressSelectorFlowController {
   
    @AuraEnabled(cacheable=true)
    public static List<ContactPointAddress> getShipToAddress(){
        try {
            //String userid = UserInfo.getUserId();
            User myUser=[Select Id,name,accountId  from user Where Id=:UserInfo.getUserId() ];
            List<ContactPointAddress> shipTolist=[select Id,Name,isDefault,Street, city,State,country,postalCode from 
            ContactPointAddress where ParentId='0017400000DDRrRAAX' and AddressType='Shipping']; 
            return shipTolist;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<ContactPointAddress> getBillToAddress(){
        try {
            //String userid = UserInfo.getUserId();
            User myUser=[Select Id,name,accountId  from user Where Id=:UserInfo.getUserId() ];
            List<ContactPointAddress> billTolist=[select Id,Name,isDefault,Street, city,State,country,postalCode from 
            ContactPointAddress where ParentId='0017400000DDRrRAAX' and AddressType='Billing'];
            return billTolist;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String createShipToAddress(String name,String street,String city,String state,
                                                 String country,String postalCode){
        User u=[Select Id,name,accountId  from user Where Id='00574000000ZhKAAA0'];
        ContactPointAddress shippingAddress=new ContactPointAddress();
        shippingAddress.name=name;
        shippingAddress.street=street;
        shippingAddress.city=city;
        shippingAddress.state=state;
        shippingAddress.country=country;
        shippingAddress.postalCode=postalCode;
        shippingAddress.AddressType='Shipping';
        shippingAddress.ParentId='0017400000DDRrRAAX';
        insert shippingAddress;
        return shippingAddress.id;
    }
    @AuraEnabled(cacheable=true)
    public static User getBuyerInfo(){

            User u=[Select Id,Name,accountId,email,phone ,Account.Name, Contact.Name,Account.PO_Enable__c from user Where Id=:'00574000000ZhKAAA0'];//:UserInfo.getUserId() ];
            return u;
    }
    @AuraEnabled
    public static WebCart getCartBillingAddress(String cartId){
       
            WebCart billTo= [select Id ,Name,  BillingStreet, BillingCity, BillingState, BillingCountry,
            BillingPostalCode from WebCart where Id=:cartId];
           return billTo;
       
    }
    @AuraEnabled
    public static CartDeliveryGroup getCartShippingAddress(String cartId){
       
            CartDeliveryGroup shipTo= [select Id,DeliverToName, DeliverToStreet, DeliverToCity, DeliverToState, DeliverToCountry ,DeliverToPostalCode  from 
            CartDeliveryGroup where CartId =:cartId];
           return shipTo;
    }
     //updateBillToAddress

     @AuraEnabled

     public static string updateBillToAddress(String cartId,String contactPointAddressId){
             ContactPointAddress billToAddlist=[select Id,Name,isDefault,Street, City,State,country,PostalCode from
             ContactPointAddress where Id=:contactPointAddressId and AddressType='Billing' Limit 1];
             WebCart billingCartAddress= [select Id ,Name,  BillingStreet, BillingCity, BillingState, BillingCountry,
             BillingPostalCode from WebCart where Id=:cartId];
             billingCartAddress.BillingStreet=billToAddlist.Street;
             billingCartAddress.BillingCity=billToAddlist.City;
             billingCartAddress.BillingState=billToAddlist.State;
             billingCartAddress.BillingCountry=billToAddlist.Country;
             billingCartAddress.BillingPostalCode=billToAddlist.PostalCode;
             update billingCartAddress;
             return 'Cart Bill to address has succesfully updated';           
     }
     @AuraEnabled

     public static string updateShipToAddress(String cartId,String contactPointAddressId){
         ContactPointAddress shippingAddresslist=[select Id,Name,isDefault,Street, City,State,country,PostalCode from
                                                  ContactPointAddress where Id=:contactPointAddressId and 
                                                  AddressType='Shipping' Limit 1];
             CartDeliveryGroup cartAddress=[select Id,DeliverToName, DeliverToStreet, DeliverToCity, DeliverToState, DeliverToCountry ,DeliverToPostalCode 
                                            from
                                            CartDeliveryGroup where CartId =:cartId];
             cartAddress.DeliverToName=shippingAddresslist.Name;
             cartAddress.DeliverToStreet=shippingAddresslist.Street;
             cartAddress.DeliverToCity=shippingAddresslist.City;
             cartAddress.DeliverToState=shippingAddresslist.State;
             cartAddress.DeliverToCountry=shippingAddresslist.Country;
             cartAddress.DeliverToPostalCode=shippingAddresslist.PostalCode;
             update cartAddress;
             return 'succesfully updated';
     }
     @AuraEnabled



public static CartDeliveryGroup updateShipToAddressWithoutContactPointAddress(String cartId,String name,String street,String city,String state,

String country,String postalCode){

/*ContactPointAddress shippingAddresslist=[select Id,Name,isDefault,Street, City,State,country,PostalCode from
    ContactPointAddress where Id=:contactPointAddressId and AddressType='Shipping' Limit 1];*/
    CartDeliveryGroup cartAddress=[select Id,DeliverToName, DeliverToStreet, DeliverToCity,
                                   DeliverToState, DeliverToCountry ,DeliverToPostalCode  from
                                   CartDeliveryGroup where CartId =:cartId];
    cartAddress.DeliverToName=name;
    cartAddress.DeliverToStreet=street;
    cartAddress.DeliverToCity=city;
    cartAddress.DeliverToState=state;
    cartAddress.DeliverToCountry=country;
    cartAddress.DeliverToPostalCode=postalCode;
    update cartAddress;
    return cartAddress;
}
 }
 
