public with sharing class CaseTriggerHandler extends TriggerHandler{
    private List<Case> newCaseList;
    private List<Case> oldCaseList;
    private Map<Id, Case> newCaseMap;
    private Map<Id, Case> oldCaseMap;

    public CaseTriggerHandler() {
        oldCaseList = (List<Case>) Trigger.old;
        newCaseList = (List<Case>) Trigger.new;
        oldCaseMap = (Map<Id, Case>) Trigger.oldMap;
        newCaseMap = (Map<Id, Case>) Trigger.newMap;
    }
  
    public override void beforeInsert() {
        CaseTriggerHelper.validateCasesAttendees(newCaseList);
    }
    public override void beforeUpdate() {
        CaseTriggerHelper.validateRequestToExternalSystem(newCaseList);
    }
    public override void afterUpdate() {
        CaseTriggerHelper.validateRequestToExternalSystem(newCaseList);
    }
}
