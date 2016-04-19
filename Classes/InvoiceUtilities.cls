global with sharing class InvoiceUtilities {
    
	// Class method to renumber Line Items for a given Invoice number.
	// Returns a string that indicates success or failure.
	webservice static String renumberLineItems(String invoiceName) {

    // create a copy of the target Invoice object and it's Line Items
    bpavlyk__Invoice__c invoice = [Select i.Name, (Select Name From bpavlyk__Line_Items__r ORDER BY Name) 
                            From bpavlyk__Invoice__c i 
                           Where i.Name = :invoiceName LIMIT 1];

    // loop through each Line Item, renumbering as you go
    Integer i = 1;
    for (bpavlyk__Line_Item__c item : invoice.bpavlyk__Line_Items__r) {
      item.Name = String.valueOf(i);
      System.debug(item.Name);
      i++;
    }

    // update the Line Items in one transaction, rollback if any problems
    // and return error messages to the calling environment
    try {
      database.update(invoice.bpavlyk__Line_Items__r);
    }
    catch (DmlException e) {
      return e.getMessage();
    }

    // on success, return a message to the calling program
    return 'Line items renumbered successfully.';
  }
}