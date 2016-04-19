public with sharing class ParentObjectTriggerHandler {
	public ParentObjectTriggerHandler() {}

	public void onBeforeInsert(List<ParentObject__c> parentsToInsert) {
		System.debug('\n\n ===> Start of ParentObjectTriggerHandler.onBeforeInsert() \n');

		Set<Id> grandParentObjectIds = this.getGrandParentObjectIds(parentsToInsert);
		Map<Id, GrandParentObject__c> grandParentObjectsById = this.getGrandParentObjectsById(grandParentObjectIds);

		for(ParentObject__c parent : parentsToInsert){
			parent.Custom_Name__c = parent.Name + '; GrandParentObject: ' + grandParentObjectsById.get(parent.GrandParentObject__c).Custom_Name__c;

			System.debug('\n\n ===> parent.Custom_Name__c: ' + parent.Custom_Name__c + '\n');
		}

		System.debug('\n\n ===> End of ParentObjectTriggerHandler.onBeforeInsert() \n');
	}


	// Helpers
	private Set<Id> getGrandParentObjectIds(List<ParentObject__c> parents) {
		Set<Id> grandParentObjectIds = new Set<Id>();

		for(ParentObject__c parent : parents){
			grandParentObjectIds.add(parent.GrandParentObject__c);
		}

		return grandParentObjectIds;
	}

	// SOQL Helper
	private Map<Id, GrandParentObject__c> getGrandParentObjectsById(Set<Id> grandParentObjectIds) {
		return new Map<Id, GrandParentObject__c>([
			SELECT Id, Custom_Name__c
			FROM GrandParentObject__c
			WHERE Id = :grandParentObjectIds
		]);
	}
}