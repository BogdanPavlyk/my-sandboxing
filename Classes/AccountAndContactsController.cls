public class AccountAndContactsController {
    
        List<Account> accounts;
    List<Contact> contacts = null;
    Id currentId;
    public List<Account> getAccounts(){

        if(accounts == null) {

            accounts = new List<Account>();
            accounts = [

                    SELECT Id, Name

                    FROM Account];
            }

        return accounts;
    }

    public List<Contact> getContacts(){
        currentId= Apexpages.currentPage().getParameters().get('currentId');
        System.debug('CURRENT ACCOUNT ID: '+currentId);
        
        if(currentId != null) {
            System.debug('CONTACTS NULL');
            contacts = new List<Contact>();

             contacts   = [

                    SELECT Id, Name, AssistantName, Department, Email, Description, Fax
                    FROM Contact
                    WHERE AccountId = :currentId] ;
            System.debug('CONTACTS: '+contacts);
            currentId = null;
        }
        
        return contacts;
    }

    public PageReference filterContacts() {
        contacts = getContacts();
       // contacts = null;
    return null; // stay on the same page
}
}