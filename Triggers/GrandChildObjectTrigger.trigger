trigger GrandChildObjectTrigger on GrandChildObject__c (before insert) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            new GrandChildObjectTriggerHandler().onBeforeInsert(Trigger.new);
        }
    }

}