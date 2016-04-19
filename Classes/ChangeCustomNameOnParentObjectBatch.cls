global class ChangeCustomNameOnParentObjectBatch implements Database.Batchable<sObject> {

	String query;
	List<Id> grandParentObjectIds;

	global ChangeCustomNameOnParentObjectBatch(List<Id> grandParentObjectIds) {
		System.debug('\n\n >>>> grandParentObjectIds: ' + grandParentObjectIds + '\n');

		this.grandParentObjectIds = grandParentObjectIds;

		this.query = '' +
			'SELECT Id, Name, GrandParentObject__r.Name, GrandParentObject__r.Custom_Name__c ' +
			'FROM ParentObject__c ' +
			'WHERE GrandParentObject__c = :grandParentObjectIds' +
		'';

		System.debug('\n\n this.query: ' + this.query + '\n');
	}

	// global (Database.QueryLocator | Iterable<sObject>) start(Database.BatchableContext bc) {}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('\n\n =========== START of ChangeCustomNameOnParentObjectBatch ==============');

		return Database.getQueryLocator(this.query);
	}

   	global void execute(Database.BatchableContext BC, List<ParentObject__c> scope) {
		System.debug('\n\n scope' + scope + '\n');

		for(ParentObject__c parent : scope){
			parent.Custom_Name__c = parent.Name + '; GrandParentObject: ' + parent.GrandParentObject__r.Custom_Name__c;
			System.debug('\n\n ===> NEW parent.Custom_Name__c: ' + parent.Custom_Name__c + '\n');
		}

		update scope;
	}

	global void finish(Database.BatchableContext BC) {
		ChangeCustomNameOnChildObjectBatch batch = new ChangeCustomNameOnChildObjectBatch(grandParentObjectIds, null);
		Database.executeBatch(batch, 200);

		System.debug('\n\n =========== END of ChangeCustomNameOnParentObjectBatch ==============');
	}

}