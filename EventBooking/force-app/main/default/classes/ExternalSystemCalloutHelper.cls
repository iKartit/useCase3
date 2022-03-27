public with sharing class ExternalSystemCalloutHelper {
    
    private static Map<Id,Account> accountsMapByCaseId(Id caseId) {
        Case myCase = [
            SELECT Id, AccountId 
            FROM Case Where Id =: caseId 
            WITH SECURITY_ENFORCED
            ];
        return 
        new Map<Id, Account>([
            SELECT ID, 
            (SELECT ID,Name,Email FROM Contacts) 
            FROM Account 
            where Id =: myCase.AccountId
            ]);
    }

    private static void emailNotifAttendee(List<String> emails){
        try {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emails;
            message.subject = 'Test';
            message.plainTextBody = 'This is the message body';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.sendEmail(messages);
        } 
        catch (Exception myExpection) {
            
        }
    }

    public static void externalSystemCallout(Id caseId) {
        Map<Id,Account> accounts = ExternalSystemCalloutHelper.accountsMapByCaseId(caseId);
        List<Contact> contacts  = accounts.values().Contacts;
        List<String> contactsEmails  = new List<String>();
        if (contacts != null && !contacts.isEmpty()) {
            for (Contact myContact : contacts) {
                HttpCalloutService calloutService = new HTTPCalloutService('AnimalsEndPointWithNamedCred');
                calloutService.setRequestBody('{"name":"'+ myContact.Name + '-' + myContact.Email  +'}');
                HTTPResponse response = calloutService.sendRequest();
                if (response.getStatusCode() != 201) {
                    System.debug('The status code returned was not expected: ' +
                        response.getStatusCode() + ' ' + response.getStatus());
                } 
                else {
                    contactsEmails.add(myContact.Email);
                }
            }
            ExternalSystemCalloutHelper.emailNotifAttendee(contactsEmails);
        }     
    }

}
