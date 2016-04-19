public with sharing class GrandChildObjectTriggerHandler {
	public GrandChildObjectTriggerHandler() {}

	public void onBeforeInsert(List<GrandChildObject__c> grandChildsToInsert) {
		System.debug('\n\n ===> Start of GrandChildObjectTriggerHandler.onBeforeInsert() \n');

		Set<Id> childObjectIds = this.getChildObjectIds(grandChildsToInsert);
		Map<Id, ChildObject__c> childObjectsById = this.getChildObjectsById(childObjectIds);

		for(GrandChildObject__c grandChild : grandChildsToInsert){
			grandChild.Custom_Name__c = grandChild.Name + '; ChildObject: ' + childObjectsById.get(grandChild.ChildObject__c).Custom_Name__c;

			System.debug('\n\n ===> grandChild.Custom_Name__c: ' + grandChild.Custom_Name__c + '\n');
		}

		System.debug('\n\n ===> End of GrandChildObjectTriggerHandler.onBeforeInsert() \n');
	}


	// Helpers
	private Set<Id> getChildObjectIds(List<GrandChildObject__c> grandChilds) {
		Set<Id> childObjectIds = new Set<Id>();

		for(GrandChildObject__c grandChild : grandChilds){
			childObjectIds.add(grandChild.ChildObject__c);
		}

		return childObjectIds;
	}

	// SOQL Helper
	private Map<Id, ChildObject__c> getChildObjectsById(Set<Id> childObjectIds) {
		return new Map<Id, ChildObject__c>([
			SELECT Id, Custom_Name__c
			FROM ChildObject__c
			WHERE Id = :childObjectIds
		]);
	}
}