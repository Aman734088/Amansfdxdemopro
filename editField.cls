public with sharing class editField{

    @AuraEnabled
    public static Map<String, Object> getUserAccId(Map<String, Object> mapName)  
    {
       String userId = (String)mapName.get('IdUser') ;
        User userData = [SELECT AccountId, Id FROM User Where Id =:userId];
        Map<String, Object> respMap = new Map<String, Object>();
        if (userData != null) {      
            respMap.put('userKey',userData);
        }
        System.debug('respMap-->'+ respMap);
        return  respMap;
    }
    @AuraEnabled       
    public static Map<String, Object> accountId(Map<String, Object> nameMap)
    {
        System.debug('nameMap-->'+nameMap);
        String idAct = (String) nameMap.get('actId');
        Account actData =[SELECT Id, ParentId  FROM Account Where Id =:idAct];
        Map<String, Object> responseMap = new Map<String, Object>();
        if (actData != null){
            responseMap.put('actKey',actData);
        }
        System.debug('responseMap-->'+ responseMap);
        return responseMap;
    }
    @AuraEnabled       
    public static Map<String, Object> parentId(Map<String, Object> parentMap)
    {
        System.debug('nameMap-->'+ parentMap);
        String idAcc = (String) parentMap.get('pId');
        ContactPointAddress parentData =[SELECT Id, ParentId,AddressType ,Address FROM ContactPointAddress Where ParentId =:idAcc and AddressType='Shipping'];
        
        Map<String, Object> CpaMap = new Map<String, Object>();
        if ( parentData != null){
            CpaMap.put('parentId',parentData);
        }
        System.debug('responseMap-->'+ CpaMap);
        return CpaMap;
    }
}