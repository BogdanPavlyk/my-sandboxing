public with sharing class TriggerExplanationHelper {
	public TriggerExplanationHelper() {}


	public static void refresh(Integer count) {
		TriggerExplanationHelper.deleteAll();

		TriggerExplanationHelper.createAll(count);
	}

	public static void createAll(Integer count) {
		TriggerExplanationHelper.createGrandParentObjects(count);

		TriggerExplanationHelper.createParentObjects(count);

		TriggerExplanationHelper.createChildObjects(count);

		TriggerExplanationHelper.createGrandChildObjects(count);
	}

	public static void createGrandParentObjects(Integer count) {
		List<GrandParentObject__c> grandParentsToInsert = new List<GrandParentObject__c>();

		for(Integer i = 0; i < count; i++){
			grandParentsToInsert.add(new GrandParentObject__c(
				Name = 'GrandParentObject #' + i
			));
		}

		insert grandParentsToInsert;

		System.debug('\n\n ===> Created GrandParentObjects: \n');
		for(GrandParentObject__c grandParent : grandParentsToInsert){
			System.debug('\n\n ===> grandParent:' + grandParent + ' \n');
		}
	}

	public static void createParentObjects(Integer count) {
		List<GrandParentObject__c> grandParents = [
			SELECT Id, Name
			FROM GrandParentObject__c
		];

		List<ParentObject__c> parentsToInsert = new List<ParentObject__c>();

		for(GrandParentObject__c grandParent : grandParents){
			for(Integer i = 0; i < count; i++){
				parentsToInsert.add(new ParentObject__c(
					GrandParentObject__c = grandParent.Id,
					Name = 'ParentObject #' + i
				));
			}
		}

		insert parentsToInsert;

		System.debug('\n\n ===> Created ParentsObjects: \n');
		for(ParentObject__c parent : parentsToInsert){
			System.debug('\n\n ===> parent:' + parent + ' \n');
		}
	}

	public static void createChildObjects(Integer count) {
		List<ParentObject__c> parents = [
			SELECT Id, Name, Custom_Name__c
			FROM ParentObject__c
		];

		List<ChildObject__c> childsToInsert = new List<ChildObject__c>();

		for(ParentObject__c parent : parents){
			for(Integer i = 0; i < count; i++){
				childsToInsert.add(new ChildObject__c(
					ParentObject__c = parent.Id,
					Name = 'ChildObject #' + i
				));
			}
		}

		insert childsToInsert;

		System.debug('\n\n ===> Created ChildObjects: \n');
		for(ChildObject__c child : childsToInsert){
			System.debug('\n\n ===> child:' + child + ' \n');
		}
	}

	public static void createGrandChildObjects(Integer count) {
		List<ChildObject__c> childs = [
			SELECT Id, Name, Custom_Name__c
			FROM ChildObject__c
		];

		List<GrandChildObject__c> grandChildsToInsert = new List<GrandChildObject__c>();

		for(ChildObject__c child : childs){
			for(Integer i = 0; i < count; i++){
				grandChildsToInsert.add(new GrandChildObject__c(
					ChildObject__c = child.Id,
					Name = 'GrandChildObject #' + i
				));
			}
		}

		insert grandChildsToInsert;

		System.debug('\n\n ===> Created GrandChildObjects: \n');
		for(GrandChildObject__c grandChild : grandChildsToInsert){
			System.debug('\n\n ===> grandChild:' + grandChild + ' \n');
		}
	}


	public static void deleteAll() {
		TriggerExplanationHelper.deleteAllGrandChildObjects();

		TriggerExplanationHelper.deleteAllChildObjects();

		TriggerExplanationHelper.deleteAllParentObjects();

		TriggerExplanationHelper.deleteAllGrandParentObjects();
	}

	public static void deleteAllGrandParentObjects() {
		List<GrandParentObject__c> grandParents = [
			SELECT Id
			FROM GrandParentObject__c
		];

		if( ! grandParents.isEmpty()) {
			delete grandParents;
		}

		System.debug('\n\n ===> grandParents.size(): ' + grandParents.size() + '\n');
	}

	public static void deleteAllParentObjects() {
		List<ParentObject__c> parents = [
			SELECT Id
			FROM ParentObject__c
		];

		if( ! parents.isEmpty()) {
			delete parents;
		}

		System.debug('\n\n ===> parents.size(): ' + parents.size() + '\n');
	}

	public static void deleteAllChildObjects() {
		List<ChildObject__c> childs = [
			SELECT Id
			FROM ChildObject__c
		];

		if( ! childs.isEmpty()) {
			delete childs;
		}

		System.debug('\n\n ===> childs.size(): ' + childs.size() + '\n');
	}

	public static void deleteAllGrandChildObjects() {
		List<GrandChildObject__c> grandChilds = [
			SELECT Id
			FROM GrandChildObject__c
		];

		if( ! grandChilds.isEmpty()) {
			delete grandChilds;
		}

		System.debug('\n\n ===> grandChilds.size(): ' + grandChilds.size() + '\n');
	}
}