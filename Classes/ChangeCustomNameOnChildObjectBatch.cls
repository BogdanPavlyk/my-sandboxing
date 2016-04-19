global class ChangeCustomNameOnChildObjectBatch implements Database.Batchable<sObject> {

	String query;
	List<Id> grandParentObjectIds;
	List<Id> parentObjectIds;

	global ChangeCustomNameOnChildObjectBatch(List<Id> grandParentObjectIds, List<Id> parentObjectIds) {
		System.debug('\n\n >>>> grandParentObjectIds: ' + grandParentObjectIds + '\n');
		System.debug('\n\n >>>> parentObjectIds: ' + parentObjectIds + '\n');

		this.grandParentObjectIds = grandParentObjectIds;
		this.parentObjectIds = parentObjectIds;

		if(grandParentObjectIds != null) {
			this.query = '' +
				'SELECT Id, Name, ParentObject__r.Custom_Name__c ' +
				'FROM ChildObject__c ' +
				'WHERE ParentObject__r.GrandParentObject__c = :grandParentObjectIds' +
			'';
		} else if(parentObjectIds != null) {
			this.query = '' +
				'SELECT Id, Name, ParentObject__r.Custom_Name__c ' +
				'FROM ChildObject__c ' +
				'WHERE ParentObject__c = :parentObjectIds' +
			'';
		} else {
			this.query = '' +
				'SELECT Id, Name, ParentObject__r.Custom_Name__c ' +
				'FROM ChildObject__c' +
			'';
		}

		System.debug('\n\n this.query: ' + this.query + '\n');
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('\n\n =========== START of ChangeCustomNameOnChildObjectBatch ==============');

		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<ChildObject__c> scope) {
		System.debug('\n\n scope' + scope + '\n');

		for(ChildObject__c child : scope){
			child.Custom_Name__c = child.Name + '; ParentObject: ' + child.ParentObject__r.Custom_Name__c;
			System.debug('\n\n ===> NEW child.Custom_Name__c: ' + child.Custom_Name__c + '\n');
		}

		update scope;
	}

	global void finish(Database.BatchableContext BC) {
		ChangeCustomNameOnGrandChildObjectBatch batch = new ChangeCustomNameOnGrandChildObjectBatch(grandParentObjectIds, null, null);
		Database.executeBatch(batch, 200);

		System.debug('\n\n =========== END of ChangeCustomNameOnChildObjectBatch ==============');
	}

}