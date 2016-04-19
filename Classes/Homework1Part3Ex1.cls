public with sharing class Homework1Part3Ex1 {
	public Homework1Part3Ex1() {

		Invoice__c inv1 = new Invoice__c( 
          Description__c = 'Invoice 7');

		Invoice__c inv2 = new Invoice__c( 
          Description__c = 'Invoice 8');

		Invoice__c inv3 = new Invoice__c( 
          Description__c = 'Invoice 9');

		List<Invoice__c> invList = new List<Invoice__c> {inv1, inv2, inv3};

		try {
			insert invList;
		} catch (DmlException de) {
			Integer numErrors = de.getNumDml();

			System.debug('getNumDml=' + numErrors);
		
			for(Integer i=0;i<numErrors;i++) {
				System.debug('getDmlFieldNames=' + de.getDmlFieldNames(i));
				System.debug('getDmlMessage=' + de.getDmlMessage(i));
			}
		}

		Merchandise__c tablet = [Select Id, Price__c From Merchandise__c Where Name = 'Tablet'];
		Merchandise__c laptop = [Select Id, Price__c From Merchandise__c Where Name LIKE 'lap%'];
		Merchandise__c monitor17 = [Select Id, Price__c From Merchandise__c Where Name = '17 Inch Monitor'];

        Line_Item__c lineItem1 = new Line_Item__c( 
          Name = '2',
          Invoice__c = inv1.Id,
          Merchandise__c = laptop.Id, 
          Unit_Price__c = laptop.Price__c, 
          Quantity__c = 10);

        Line_Item__c lineItem2 = new Line_Item__c( 
          Name = '1',
          Invoice__c = inv2.Id,
          Merchandise__c = monitor17.Id, 
          Unit_Price__c = monitor17.Price__c, 
          Quantity__c = 25);

        Line_Item__c lineItem3 = new Line_Item__c( 
          Name = '2',
          Invoice__c = inv2.Id,
          Merchandise__c = tablet.Id, 
          Unit_Price__c = tablet.Price__c, 
          Quantity__c = 20);

         Line_Item__c lineItem4 = new Line_Item__c( 
          Name = '1',
          Invoice__c = inv3.Id,
          Merchandise__c = monitor17.Id, 
          Unit_Price__c = monitor17.Price__c, 
          Quantity__c = 50);                   
          
        insert lineItem1;
        insert lineItem2;
        insert lineItem3;
        insert lineItem4;

//   Set<Invoice__c> parentsSet = [Select Id From Invoice__c];

// ///////////////
//List<Id> grandParentObjectIds = new List<Id>();

//this.grandParentObjectsIds = grandParentObjectIds;
//this.parentObjectsIds = parentObjectsIds;

//	this.query = ''+
//		'SELECT Id, Name, GrandParentObject__r.Custom.Name__c' +
//		'FROM ParentObject__c' +
//		'WHERE GrandParent__c = :GrandParentObjectIds' +
//		'';

//'Map SOQL WHERE':
//	'prefix': 'msoqlw'
//	'body': """
//		Map<${1:Id}, ${2:SObject}, ${3:sObjectMap} = new Map<${1:Id}, ${2:SObject}>
 }
}