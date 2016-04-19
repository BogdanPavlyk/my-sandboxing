public with sharing class Homework1Part3Ex2 {

	public Set<Id> invoiceIds;

	public Homework1Part3Ex2() {

		List<Line_Item__c> lineItems = [
			Select Id, Name, Line_Item__c.Merchandise__r.Name, Line_Item__c.Invoice__c
			FROM Line_Item__c
			WHERE Line_Item__c.Merchandise__r.Name = 'Laptop'
			];

		// 2) Выберите Id всех Parents и поместите их в сет.(Моя связь Invoice => Line_Item)
		this.invoiceIds = this.getInvoiceIds(lineItems);

		// 3) Выберите всех чаилдов ссылки на родителей которых находятся в сете (1) и поместите в лист.
		List<Line_Item__c> allLineItems = new List<Line_Item__c>(this.getAllLineItemsByInvoicesIds(invoiceIds));
 		
 		//4) Создайте еще один экземпляр Parent - Child и поместите в сет (1) Parent Id.
 		
 		//createInvoiceAndLineItems(3);

 		this.invoiceIds.addAll(new Map<Id, Invoice__c>([
 			SELECT Id
 			FROM Invoice__c
 			WHERE Description__c = 'Invoice created for exercise'
 		]).keySet());

 		System.debug('Invoice Ids: ' + invoiceIds + '\n' + this.getInvoicesById(invoiceIds));

 		// 5) В цикле сделайте Update поля для одного child каждого parent (присвойте стринговое значение 
		// полю name или сделайте апдейт какого-либо числового поля). Сделайте выборку записей у которых 
		// прошел апдейт (например, имена которых = 'update 1'). Выведите результат в дебаг.
		//this.updateOneLineItemForEveryInvoiceByIds(invoiceIds);	

		// 6) Сделайте выборку всех запсей Child. И поместите в мапу <ParentId, Child>
		this.createInvoiceIdWithLineItemsMap(invoiceIds);

	}


	//Helpers
	private void createInvoiceIdWithLineItemsMap(Set<Id> invoiceIds){
		Map<Id, List<Line_Item__c>> invoiceIdWithLineItemsMap = new Map<Id, List<Line_Item__c>>();

		List<Invoice__c> invoicesAndHisLineItems = getInvoicesAndHisLineItemsByIds(invoiceIds);

  		for(Invoice__c a: invoicesAndHisLineItems){

     		List<Line_Item__c> lineItemsOfInvoice = new List<Line_Item__c>();

     		for(Line_Item__c c: a.Line_Items__r){
   	  			
   	  			lineItemsOfInvoice.add(c);
     		}  

     		invoiceIdWithLineItemsMap.put(a.Id, lineItemsOfInvoice); 
     		System.debug('Map <InvoiceId = '+a.Id+',\nList<Line_Item>: '+ lineItemsOfInvoice+'\n');  
   		}
	}

	private void updateOneLineItemForEveryInvoiceByIds(Set<Id> invoiceIds){
		List<Line_Item__c> lineItemsToUpdate = new List<Line_Item__c>();
		List<Invoice__c> invoicesAndHisLineItems = this.getInvoicesAndHisLineItemsByIds(invoiceIds);

		for( Invoice__c inv : invoicesAndHisLineItems){
			inv.Line_Items__r[0].Name = 'update 1';
			lineItemsToUpdate.add(inv.Line_Items__r[0]); 
		}
		update lineItemsToUpdate;

		System.debug([SELECT Id,Name, Merchandise__c FROM Line_Item__c WHERE Name = 'update 1']);

	}

	public static void createInvoiceAndLineItems(Integer count) {

		Invoice__c invoice = new Invoice__c( Description__c = 'Invoice created for exercise' );
		insert invoice;

		List<Line_Item__c> lineItemsToInsert = new List<Line_Item__c>();

		Merchandise__c[] merches = [
						SELECT Id
						FROM Merchandise__c
						LIMIT :count
					];

		for(Integer i = 1; i <= count; i++){
				lineItemsToInsert.add(new Line_Item__c(
					Invoice__c = invoice.Id,
					Name = '' + i,
					Quantity__c = 2*i+10,
					Merchandise__c = merches[i-1].Id
				));
		}

		try{
		insert lineItemsToInsert;
		} catch (DmlException de) {
			Integer numErrors = de.getNumDml();
			for(Integer i=0;i<numErrors;i++) {
				System.debug('getDmlFieldNames=' + de.getDmlFieldNames(i));
				System.debug('getDmlMessage=' + de.getDmlMessage(i));
			}
		}


		System.debug('\n\n ===> Created Line Items: \n');
		for(Line_Item__c lineItem : lineItemsToInsert){
			System.debug('\n\n ===> Line Item:' + lineItem + ' \n');
		}
	}

	private List<Line_Item__c> getAllLineItemsByInvoicesIds(Set<Id> invoiceIds){

		List<Invoice__c> invoicesAndHisLineItems = this.getInvoicesAndHisLineItemsByIds(invoiceIds);
  		List<Line_Item__c> allLineItems = new List<Line_Item__c>();

  		for(Invoice__c a: invoicesAndHisLineItems){
     		
     		for(Line_Item__c c: a.Line_Items__r){
   	  			System.debug('Line_Item Id[' + c.Id + '] , Line_Item Name[' + c.Name +']\n\n');
   	 			
   	  			allLineItems.add(c);
     		}    	  
   		}
   		System.debug('All Line Items list: ' + allLineItems);

   		return allLineItems;
	}

	private Set<Id> getInvoiceIds(List<Line_Item__c> lineItems) {
		Set<Id> invoiceIds = new Set<Id>();

		for(Line_Item__c lineItem : lineItems){
			invoiceIds.add(lineItem.Invoice__c);
		}

		return invoiceIds;
	}

	//SOQL Helpers
	private Map<Id, Invoice__c> getInvoicesById(Set<Id> invoiceIds) {
		return new Map<Id, Invoice__c>([
			SELECT Id, Description__c, Name
			FROM Invoice__c
			WHERE Id = :invoiceIds
		]);
	}

	public List<Invoice__c> getInvoicesAndHisLineItemsByIds(Set<Id> invoiceIds) { 
		return new List<Invoice__c>([
			SELECT Id, Name, Description__c, (Select Id, Name, Invoice__r.Id From Line_Items__r)
			FROM Invoice__c
			WHERE Id = :invoiceIds
		]) ;
	}

}