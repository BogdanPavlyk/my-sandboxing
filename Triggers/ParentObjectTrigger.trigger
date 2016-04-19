trigger ParentObjectTrigger on ParentObject__c (before insert) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            new ParentObjectTriggerHandler().onBeforeInsert(Trigger.new);
        }
    }

}