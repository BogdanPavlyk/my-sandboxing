global class ChangeCustomNameOnGrandChildObjectBatch implements Database.Batchable<sObject> {

	String query;
	List<Id> grandParentObjectIds;
	List<Id> parentObjectIds;
	List<Id> childIds;

	global ChangeCustomNameOnGrandChildObjectBatch(List<Id> grandParentObjectIds, List<Id> parentObjectIds, List<Id> childIds) {
		System.debug('\n\n >>>> grandParentObjectIds: ' + grandParentObjectIds + '\n');
		System.debug('\n\n >>>> parentObjectIds: ' + parentObjectIds + '\n');
		System.debug('\n\n >>>> parentObjectIds: ' + childIds + '\n');

		this.grandParentObjectIds = grandParentObjectIds;
		this.parentObjectIds = parentObjectIds;
		this.childIds = childIds;

		if(grandParentObjectIds != null) {
			this.query = '' +
				'SELECT Id, Name, ChildObject__r.Custom_Name__c ' +
				'FROM GrandChildObject__c '+
				'WHERE ChildObject__r.ParentObject__r.GrandParentObject__c = :grandParentObjectIds' +
			'';
		} else if(parentObjectIds != null) {
			this.query = '' +
				'SELECT Id, Name, ChildObject__r.Custom_Name__c ' +
				'FROM GrandChildObject__c '+
				'WHERE ChildObject__r.ParentObject__c = :parentObjectIds' +
			'';
		} else if(childIds != null) {
			this.query = '' +
				'SELECT Id, Name, ChildObject__r.Custom_Name__c ' +
				'FROM GrandChildObject__c' +
				'WHERE ChildObject__c = :childIds' +
			'';
		} else {
			this.query = '' +
				'SELECT Id, Name, ChildObject__r.Custom_Name__c ' +
				'FROM GrandChildObject__c' +
			'';
		}

		System.debug('\n\n this.query: ' + this.query + '\n');
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('\n\n =========== START of ChangeCustomNameOnGrandChildObjectBatch ==============');

		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<GrandChildObject__c> scope) {
		System.debug('\n\n scope' + scope + '\n');

		for(GrandChildObject__c grandChild : scope){
			grandChild.Custom_Name__c = grandChild.Name + '; ChildObject: ' + grandChild.ChildObject__r.Custom_Name__c;
			System.debug('\n\n ===> NEW grandChild.Custom_Name__c: ' + grandChild.Custom_Name__c + '\n');
		}

		update scope;
	}

	global void finish(Database.BatchableContext BC) {

		System.debug('\n\n =========== END of ChangeCustomNameOnGrandChildObjectBatch ==============');
	}

}