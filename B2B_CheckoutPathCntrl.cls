public with sharing class B2B_CheckoutPathCntrl {  
    @AuraEnabled(cacheable=true)
    public static String findCheckOutNextStep(string cartID){

        String defaultStep = 'Start';
        List<CartCheckoutSession> lstCartSession  = [SELECT Id,CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, WebCartId, State, NextState, IsProcessing, 
        BackgroundOperationId, IsArchived, OrderId, IsError FROM 
        CartCheckoutSession where WebCartId  =: cartID Order by LastModifiedDate desc Limit 1];
        System.debug('lstCartSession '+cartID);
        System.debug('lstCartSession '+lstCartSession);

        List<OrderSummary> lstOrderSum = [SELECT Id,Status, SalesStoreId FROM OrderSummary where id =: cartID AND Status = 'Created' Limit 1];

        if(!lstCartSession.IsEmpty()){

            defaultStep = lstCartSession[0].State;
            System.debug('lstCartSession '+defaultStep);
        }

        if(!lstOrderSum.IsEmpty() && defaultStep == 'Start')
        {
            defaultStep = 'Order Confirmation';
        }
        System.debug('checkout path-----'+defaultStep);
        return defaultStep.trim();
    }
}