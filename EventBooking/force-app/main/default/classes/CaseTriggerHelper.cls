public with sharing class CaseTriggerHelper {

    public static void validateCasesAttendees(List<Case> cases) {
        Set<Id> accountIds = CaseTriggerHelper.accountsSetByCase(cases);
        Map<Id,Account> accounts = CaseTriggerHelper.accountsMapById(accountIds);
        

        for (Case myCase : cases) {
            if(myCase.AccountId != null && accounts.containsKey(myCase.AccountId)) {
                Account acct = accounts.get(myCase.AccountId);
                Integer contactsCount = acct.Contacts.size();
                if (contactsCount == 0) {
                    myCase.addError(Constants.REQUIRE_CONTACTS_FOR_ACCOUNT_CREATION);
                }else if (myCase.Origin == Constants.WEB && contactsCount >= 2) {
                    myCase.addError(Constants.EXEEDED_ONE_ATTENDEE_PER_WEB_REQUEST);
                }else if (myCase.Origin == Constants.PHONE && contactsCount >= 4) {
                    myCase.addError(Constants.EXCEEDED_THREE_ATTENDEES_PER_PHONE_REQUEST);
                }
            }else {
                myCase.addError(Constants.ATTACHING_ACCOUNT_FOR_REQUEST_CREATION);
            }
        }
    }
    
    public static void validateRequestToExternalSystem(List<Case> cases) {
        for (Case myCase : cases) {
            if (myCase.Status == Constants.CLOSED) {
                ExternalSystemCalloutService.registerAttendees(myCase.Id);
            }
        }
    }

    public static Set<Id> accountsSetByCase(List<Case> cases ) {
        Set<Id> accountIds = new Set<Id>();

        for(Case myCase : cases) {
            if(myCase.AccountId != null) {
               accountIds.add(myCase.AccountId);
            }
         }
        return accountIds;
    }

    public static Map<Id,Account> accountsMapById(Set<Id> accountIds) {
        return new Map<Id, Account>([SELECT ID, (select id from contacts) FROM Account where id in :accountIds]);
    }

   
    
}