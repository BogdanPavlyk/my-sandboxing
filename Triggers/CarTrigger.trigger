trigger CarTrigger on bpavlyk__Car__c (before insert, before update) {

	if(Trigger.isBefore) {
        if(Trigger.isInsert) {
           	new CarTriggerHandler().onBeforeInsert(Trigger.new);
        } else if(Trigger.isUpdate) {
    
        }
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
           
        } else if(Trigger.isUpdate){

        }
    }
}