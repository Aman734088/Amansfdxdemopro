public with sharing class B2BGetInfo {
    @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductDetail getProduct(
      String communityId,
      String productId,
      String effectiveAccountId
    ) {
      // Lookup the webstore ID associated with the community
      String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
  
      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCatalog_static_methods.htm#apex_ConnectAPI_CommerceCatalog_static_methods
      return ConnectApi.CommerceCatalog.getProduct(
        webstoreId,
        productId,
        effectiveAccountID,
        null,
        false,
        null,
        false,
        true,
        false
      );
    }
  
    @AuraEnabled(cacheable=true)

    public static boolean checkProductIsInStock(String productId) {
  
      /*
  
       * The following is an example of calling an external API.
  
       * The example API provided is extremely simple: It takes in a product id
  
       * and returns a true or false value for inStock based on whether the 15th char is odd or even.
  
       *
  
       * To access this endpoint on your org, go to Remote Site Settings in Setup as an admin user
  
       * click "New Remote Site" and provide "https://inventorymanagerdemo.herokuapp.com" for the "Remote Site URL" field
  
       */
  
      // Http http = new Http();
  
      // HttpRequest request = new HttpRequest();
  
      // String endpoint =
  
      //   'https://inventorymanagerdemo.herokuapp.com/api/inventory/' + productId;
  
      // request.setEndpoint(endpoint);
  
      // request.setMethod('GET');
  
      // HttpResponse response = http.send(request);
  
      // // If the request is successful, parse the JSON response.
  
      // if (response.getStatusCode() == 200) {
  
      //   // Deserialize the JSON string into collections of primitive data types.
  
      //   Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
  
      //     response.getBody()
  
      //   );
  
      //   return (boolean) results.get('inStock');
  
      // } else {
  
      //   return false;
  
      // } 
        Decimal res=0;  
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();  
        String endPoint = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c/' + productId;
        request.setEndpoint(endPoint);  
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); 
        request.setMethod('GET'); 
            HttpResponse response = http.send(request);  
            System.debug(response); 
            if (response.getStatusCode() == 200) 
        { 
            system.debug(JSON.deserializeUntyped(response.getBody()));  
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
            res=(Decimal)results.get('Available_quantity__c');  
            System.debug(results); 
        } 
        if(res>0.00)  
            { 
            return true; 
            } 
            else  
            { 
              return false;  
            }
    }
    @AuraEnabled(cacheable=true)

  public static Decimal checkProduct(String productId) {
    /*
     * The following is an example of calling an external API.
     * The example API provided is extremely simple: It takes in a product id
     * and returns a true or false value for inStock based on whether the 15th char is odd or even.
     *
     * To access this endpoint on your org, go to Remote Site Settings in Setup as an admin user
     * click "New Remote Site" and provide "https://inventorymanagerdemo.herokuapp.com" for the "Remote Site URL" field
     */
    // Http http = new Http();
    // HttpRequest request = new HttpRequest();
    // String endpoint =

    //   'https://inventorymanagerdemo.herokuapp.com/api/inventory/' + productId;

    // request.setEndpoint(endpoint);

    // request.setMethod('GET');

    // HttpResponse response = http.send(request);

    // // If the request is successful, parse the JSON response.

    // if (response.getStatusCode() == 200) {

    //   // Deserialize the JSON string into collections of primitive data types.

    //   Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(

    //     response.getBody()

    //   );

    //   return (boolean) results.get('inStock');

    // } else {

    //   return false;

    // }
      Decimal res=0;
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      String endPoint = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c/' + productId;

      request.setEndpoint(endPoint);
      request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
      request.setMethod('GET');
          HttpResponse response = http.send(request);
          System.debug(response);
          if (response.getStatusCode() == 200)
      {
          system.debug(JSON.deserializeUntyped(response.getBody()));
          Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
          res=(Decimal)results.get('Available_quantity__c');
          System.debug(results);
      }
      // if(res<=0.00)
      //     {
      //     return true;
      //     }
      //     else
      //     {
      //       return false;
      //     }

      return res;
  }
  
    @AuraEnabled
    public static ConnectApi.CartSummary getCartSummary(
      String communityId,
      String effectiveAccountId
    ) {
      // Lookup the webstore ID associated with the community
      String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
  
      //'current' is available in version 50.0 and later and indicates a cart with a status that isn’t Closed or PendingDelete
      //This is important for the product detail page since we are using the cart summary to check if the status is "Processing" or "Checkout"
      String activeCartOrId = 'current';
  
      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
      return ConnectApi.CommerceCart.getCartSummary(
        webstoreId,
        effectiveAccountId,
        activeCartOrId
      );
    }
  
    @AuraEnabled
    public static ConnectApi.CartItem addToCart(
      String communityId,
      String productId,
      String quantity,
      String effectiveAccountId
    ) {
      // Lookup the webstore ID associated with the community
      String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
  
      ConnectApi.CartItemInput cartInput = new ConnectApi.CartItemInput();
      cartInput.productId = productId;
      cartInput.quantity = quantity;
      cartInput.type = ConnectApi.CartItemType.PRODUCT;
      // updateReserved(quantity,productId);
  
      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm#apex_ConnectAPI_CommerceCart_static_methods
      return ConnectApi.CommerceCart.addItemToCart(
        webstoreId,
        effectiveAccountId,
        'active',
        cartInput
      );
    }
    
    @AuraEnabled
    public static ConnectApi.Wishlist createAndAddToList(
      String communityId,
      String productId,
      String wishlistName,
      String effectiveAccountId
    ) {
      // Lookup the webstore ID associated with the community
      String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
  
      // Store the product in a WishlistItemInput to pass to the Wishlist
      ConnectApi.WishlistItemInput wishlistItemInput = new ConnectApi.WishlistItemInput();
      wishlistItemInput.productId = productId;
  
      //Create a wishlistInput to be created
      ConnectApi.WishlistInput wishlistInput = new ConnectApi.WishlistInput();
      wishlistInput.name = wishlistName;
      wishlistInput.products = new List<ConnectApi.WishlistItemInput>{
        wishlistItemInput
      };
  
      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceWishlist_static_methods.htm#apex_ConnectAPI_CommerceWishlist_static_methods
      return ConnectApi.CommerceWishlist.createWishlist(
        webstoreId,
        effectiveAccountId,
        wishlistInput
      );
    }
    @AuraEnabled
       public static Case newCase(String descr, String userId){
       User cname = [SELECT Id, ContactId from User WHERE Id=:userId];
       Contact Cntname  = [SELECT Id, AccountId, Name from Contact WHERE Id=:cname.ContactId];
      Case cs = new Case();
      try {
          cs.Description = descr;
          //cs.OwnerId = '00GDS00000B43Fk2AJ';
          cs.ContactId = Cntname.Id;
          cs.AccountId = Cntname.AccountId;
          insert cs;
          return cs;
      } catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }
  }
  
    @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductPrice getProductPrice(
      String communityId,
      String productId,
      String effectiveAccountId
    ) {
      // Lookup the webstore ID associated with the community
      String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
  
      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceStorePricing_static_methods.htm#apex_ConnectAPI_CommerceStorePricing_static_methods
      return ConnectApi.CommerceStorePricing.getProductPrice(
        webstoreId,
        productId,
        effectiveAccountId
      );
    }
    @AuraEnabled(cacheable=true)
  public static Void reservedInventory(String sku, Decimal reservedQuantity, String productId){
  system.debug(productId);
  Map<String, Object> getdatamp = getInventoryReserved(productId);
  Decimal oldReservedQty = (Decimal)getdatamp.get('Reserved_quantity__c');
  if(oldReservedQty!=null)
  {
  reservedQuantity += oldReservedQty;
  }
  Http http = new Http();
  HttpRequest request = new HttpRequest();
  request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c/'+sku);
  request.setBody('{"Reserved_quantity__c":'+reservedQuantity+'}');
  request.setMethod('PATCH');
  request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
  request.setHeader('Content-Type', 'application/json');
  HttpResponse response = http.send(request);
  System.debug(response);
}
@AuraEnabled(cacheable=true)
  public static Map<String,Object> getInventoryReserved(String productId){
      system.debug(productId);
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      String endpoint = Url.getOrgDomainUrl().toExternalForm() +'/services/apexrest/Inventory__c/' + productId;
      request.setEndpoint(endpoint);
      request.setMethod('GET');
      request.setHeader('Authorization', 'Bearer '+UserInfo.getSessionID());
      request.setHeader('Content-Type', 'application/json');
      HttpResponse response = http.send(request);
      // If the request is successful, parse the JSON response.
      //decimal stck =2.0;
      Map<String, Object> results = new Map<String, Object>();
      if (response.getStatusCode() == 200) {
        // Deserialize the JSON string into collections of primitive data types.
        results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return results;
      }
      return results;
  }
  @AuraEnabled(cacheable=true)
    public static void myCartItem(String cartItemId)
    {
        Decimal reserved=0.0;
        cartItem myCart= [Select Id,Quantity,Product2Id,sku from cartItem where Id =:cartItemId limit 1];
        reserved=mycart.quantity;
        Map<String, object> getRes=getInventoryReserved(myCart.Product2Id);
        Decimal myreserveditem=(Decimal)getRes.get('Reserved_quantity__c');
        if(myreserveditem!=null)
        {
          reserved = myreserveditem-reserved;
        }
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() +'/services/apexrest/Inventory__c/Reserved_quantity__c/'+myCart.sku);
        request.setBody('{"Reserved_quantity__c":'+reserved+'}');
        request.setMethod('PATCH');
        request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        System.debug(response);
    }

    @AuraEnabled(cacheable=true)
     public static void myCartItems(String cartItemId, Decimal quantity)
  {
    Decimal reserved=0.0;
    cartItem myCart= [SELECT Id,Quantity,Product2Id,sku from cartItem where Id =:cartItemId limit 1];
    reserved=quantity;
    Map<String, object> getRes=getInventoryReserved(myCart.Product2Id);
     Decimal myreserveditem=(Decimal)getRes.get('Reserved_quantity__c');
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() +'/services/apexrest/Inventory__c/Reserved_quantity__c/'+myCart.sku);
      request.setBody('{"Reserved_quantity__c":'+reserved+'}');
      request.setMethod('PATCH');
      request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
      request.setHeader('Content-Type', 'application/json');
    HttpResponse response = http.send(request);
    System.debug(response);
    }
  }