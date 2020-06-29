public with sharing class ClientMessageHelper {
    // email template names
    public static final String INITIAL_CLIENT_REFERRAL_TEMPLATE = 'Initial_Client_Referral';
    public static final String CLIENT_REFERRAL_FOLLOWUP_TEMPLATE = 'Client_Referral_Followup';

    public static List<Messaging.SingleEmailMessage> createInitialClientReferralEmails(Map<Id, Referral__c> referralMap) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        // get the email template for this kind of message
        EmailTemplate template = getEmailTemplateByName(INITIAL_CLIENT_REFERRAL_TEMPLATE);

        for (Id referralId : referralMap.keySet()) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(template.Id);
            message.setTargetObjectId(referralMap.get(referralId).Contact__c);
            message.setWhatId(referralId);
            message.setUseSignature(false);
            messages.add(message);
        }

        return messages;
    }

    public static List<Messaging.SingleEmailMessage> createReferralFollowupEmails(Map<Id, Referral__c> referralMap) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        // get the email template for this kind of message
        EmailTemplate template = getEmailTemplateByName(CLIENT_REFERRAL_FOLLOWUP_TEMPLATE);

        for (Id referralId : referralMap.keySet()) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(template.Id);
            message.setTargetObjectId(referralMap.get(referralId).Contact__c);
            message.setWhatId(referralId);
            message.setUseSignature(false);
            messages.add(message);
        }

        return messages;
    }

    private static EmailTemplate getEmailTemplateByName(String templateName) {
        EmailTemplate template = [
            SELECT
                Id,
                DeveloperName
            FROM EmailTemplate
            WHERE DeveloperName = :templateName
        ][0];
        return template;
    }

    public static Map<Id,Messaging.SingleEmailMessage> getContactEmailMap(List<Messaging.SingleEmailMessage> emails) {
        Map<Id,Messaging.SingleEmailMessage> contactEmailMap = new Map<Id,Messaging.SingleEmailMessage>();
        for (Messaging.SingleEmailMessage email : emails) {
            contactEmailMap.put(email.getTargetObjectId(), email);
        }
        return contactEmailMap;
    }

    public static Map<Id, Referral__c> getReferralRecords(List<Id> referralIds) {
        Map<Id, Referral__c> referralMap = new Map<Id, Referral__c>();
        
        List<Referral__c> referrals = [
            SELECT
                Id,
                Contact__c
            FROM Referral__c
            WHERE Id IN :referralIds
        ];
        for (Referral__c refer : referrals) {
            referralMap.put(refer.Id, refer);
        }

        return referralMap;
    }

}