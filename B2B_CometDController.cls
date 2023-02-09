public without sharing class B2B_CometDController {
    @AuraEnabled(cacheable=true)
    public static String getSessionId() {
    return UserInfo.getSessionId();
}
}