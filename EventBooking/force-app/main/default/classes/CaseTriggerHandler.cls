public with sharing class CaseTriggerHandler extends TriggerHandler{
    private List<Account> oldAccountList, newAccountList;
    private Map<Id, Account> oldAccountMap, newAccountMap;
  
    public CaseTriggerHandler() {
        oldCaseList = (List<Case>) Trigger.old;
        newCaseList = (List<Case>) Trigger.new;
        oldCaseMap = (Map<Id, Case>) Trigger.oldMap;
        newCaseMap = (Map<Id, Case>) Trigger.newMap;
    }
  
    protected override void beforeInsert() {
        //AccountTriggerHelper.doSomeBusinessRequirement(newAccountList);
    }

    protected override void afterUpdate() {
        //AccountTriggerHelper.updateRelatedContacts(newAccountMap);
    }

    //To bypass
    // protected override void afterUpdate() {
    //     TriggerHandler.bypass('ContactTriggerHandler');
    //     AccountTriggerHelper.updateRelatedContacts(newAccountMap);
    //     TriggerHandler.clearBypass('ContactTriggerHandler');
    // }
}
