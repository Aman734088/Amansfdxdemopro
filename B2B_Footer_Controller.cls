public with sharing class B2B_Footer_Controller {
    public B2B_Footer_Controller() {

    }
    @AuraEnabled
    public static string newCase(String comment,String ownerId){
        User u1=[SELECT Id,email,contactId FROM User where Id=:ownerId limit 1];
        Case c = new Case();
            c.ownerId = ownerId;
            c.Origin = 'Web';
            c.Status = 'New';
            c.Description=comment;
            c.SuppliedEmail=u1.email;
            c.contactId=u1.contactId;
            
        try {
            insert c;
            return 'case created succesfully';
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string newLead(String firstName,String lastName,String email,String company,String comment){
        
        Lead ld = new Lead();
                ld.LeadSource = 'Web';
                ld.FirstName = firstName;
                ld.LastName = lastName;
                ld.Email = email;
                ld.Status='New';
                ld.Company= company;
                ld.Description=comment;  
                       
        try {
            
            insert ld;
            return 'Lead created succesfully';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }       
    }
}