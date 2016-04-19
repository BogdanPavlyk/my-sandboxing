public with sharing class GrandParentObjectTriggerHandler {
	public GrandParentObjectTriggerHandler() {}

	public void onBeforeInsert(List<GrandParentObject__c> grandParentsToInsert) {
		System.debug('\n\n ===> Start of GrandParentObjectTriggerHandler.onBeforeInsert() \n');

		for(GrandParentObject__c grandParent : grandParentsToInsert){
			grandParent.Custom_Name__c = grandParent.Name;

			System.debug('\n\n ===> grandParent.Custom_Name__c: ' + grandParent.Custom_Name__c + '\n');
		}

		System.debug('\n\n ===> End of GrandParentObjectTriggerHandler.onBeforeInsert() \n');
	}

	public void onBeforeUpdate(List<GrandParentObject__c> grandParentsToUpdate, Map<Id, GrandParentObject__c> oldGrandParents) {
		System.debug('\n\n ===> Start of GrandParentObjectTriggerHandler.onBeforeUpdate() \n');

		for(GrandParentObject__c grandParent : grandParentsToUpdate){
			if(grandParent.Name != oldGrandParents.get(grandParent.Id).Name) {
				grandParent.Custom_Name__c = grandParent.Name;
				System.debug('\n\n ===> NEW grandParent.Custom_Name__c: ' + grandParent.Custom_Name__c + '\n');
			}
		}

		System.debug('\n\n ===> End of GrandParentObjectTriggerHandler.onBeforeUpdate() \n');
	}

	public void onAfterUpdate(List<GrandParentObject__c> grandParentsToUpdate, Map<Id, GrandParentObject__c> oldGrandParents) {
		System.debug('\n\n ===> Start of GrandParentObjectTriggerHandler.onAfterUpdate() \n');

		// Map<Id, GrandParentObject__c> getGrandParentObjectsWithParentsById = this.getGrandParentObjectsWithParentsByIdWithIds(oldGrandParents.keySet());
		// System.debug('\n\n ===> getGrandParentObjectsWithParentsById: ' + getGrandParentObjectsWithParentsById + '\n');
		//
		// List<ParentObject__c> parentObjectsToUpdate = new List<ParentObject__c>();
		//
		// for(GrandParentObject__c grandParent : grandParentsToUpdate){
		// 	if(grandParent.Name != oldGrandParents.get(grandParent.Id).Name) {
		// 		List<ParentObject__c> parents =  getGrandParentObjectsWithParentsById.get(grandParent.Id).ParentObjects__r;
		//
		// 		for(ParentObject__c parent : parents){
		// 			parent.Custom_Name__c = parent.Name + '; GrandParentObject: ' + grandParent.Name;
		// 			System.debug('\n\n ===> NEW parent.Custom_Name__c: ' + parent.Custom_Name__c + '\n');
		//
		// 			parentObjectsToUpdate.add(parent);
		// 		}
		// 	}
		// }
		//
		// update parentObjectsToUpdate;





		List<Id> changedGrandParentObjectIds = new List<Id>();

		for(GrandParentObject__c grandParent : grandParentsToUpdate){
			if(grandParent.Name != oldGrandParents.get(grandParent.Id).Name) {
				changedGrandParentObjectIds.add(grandParent.Id);
			}
		}

		ChangeCustomNameOnParentObjectBatch batch = new ChangeCustomNameOnParentObjectBatch(changedGrandParentObjectIds);
		Database.executeBatch(batch, 200);

		System.debug('\n\n ===> End of GrandParentObjectTriggerHandler.onAfterUpdate() \n');
	}

	// SOQL Helper
	private Map<Id, GrandParentObject__c> getGrandParentObjectsWithParentsByIdWithIds(Set<Id> grandParentObjectIds) {
		return new Map<Id, GrandParentObject__c>([
			SELECT Id, (SELECT Id, Name, Custom_Name__c FROM ParentObjects__r)
			FROM GrandParentObject__c
			WHERE Id = :grandParentObjectIds
		]);
	}
}