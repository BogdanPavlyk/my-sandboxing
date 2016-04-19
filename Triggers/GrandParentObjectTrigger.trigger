trigger GrandParentObjectTrigger on GrandParentObject__c (before insert, before update, after update) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            new GrandParentObjectTriggerHandler().onBeforeInsert(Trigger.new);
        } else if(Trigger.isUpdate) {
            new GrandParentObjectTriggerHandler().onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            new GrandParentObjectTriggerHandler().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}