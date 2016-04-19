trigger CarPriceTrigger on bpavlyk__Car_Price__c (before insert, before update, after insert, after update) {

	if(Trigger.isBefore) {
        if(Trigger.isInsert) {
           	new CarPriceTriggerHandler().onBeforeInsert(Trigger.new);
        } else if(Trigger.isUpdate) {
            new CarPriceTriggerHandler().onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            new CarPriceTriggerHandler().onAfterInsert(Trigger.new, Trigger.newMap);
        } else if(Trigger.isUpdate){
            new CarPriceTriggerHandler().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}