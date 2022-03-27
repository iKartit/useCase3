public with sharing class ExternalSystemCalloutService {
    
    public static void registerAttendees(Id caseId) {
        ExternalSystemCalloutHelper.externalSystemCallout(caseId);
    }
    
}
