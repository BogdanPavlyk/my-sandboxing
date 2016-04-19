public with sharing class ChildObjectTriggerHandler {
	public ChildObjectTriggerHandler() {}

	public void onBeforeInsert(List<ChildObject__c> childsToInsert) {
		System.debug('\n\n ===> Start of ChildObjectTriggerHandler.onBeforeInsert() \n');

		Set<Id> parentObjectIds = this.getParentObjectIds(childsToInsert);
		Map<Id, ParentObject__c> parentObjectsById = this.getParentObjectsById(parentObjectIds);

		for(ChildObject__c child : childsToInsert){
			child.Custom_Name__c = child.Name + '; ParentObject: ' + parentObjectsById.get(child.ParentObject__c).Custom_Name__c;

			System.debug('\n\n ===> child.Custom_Name__c: ' + child.Custom_Name__c + '\n');
		}

		System.debug('\n\n ===> End of ChildObjectTriggerHandler.onBeforeInsert() \n');
	}


	// Helpers
	private Set<Id> getParentObjectIds(List<ChildObject__c> childs) {
		Set<Id> parentObjectIds = new Set<Id>();

		for(ChildObject__c child : childs){
			parentObjectIds.add(child.ParentObject__c);
		}

		return parentObjectIds;
	}

	// SOQL Helper
	private Map<Id, ParentObject__c> getParentObjectsById(Set<Id> parentObjectIds) {
		return new Map<Id, ParentObject__c>([
			SELECT Id, Custom_Name__c
			FROM ParentObject__c
			WHERE Id = :parentObjectIds
		]);
	}
}