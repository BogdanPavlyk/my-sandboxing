trigger ChildObjectTrigger on ChildObject__c (before insert) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            new ChildObjectTriggerHandler().onBeforeInsert(Trigger.new);
        }
    }

}