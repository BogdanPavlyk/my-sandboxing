public with sharing class AccountCustomEditExtension {

    private Account account;
    public Account getAccount(){ return this.account;} 
    public void setAccount(Account account){ this.account = account;} 
    
    public boolean flag {get; set;}
    private ApexPages.StandardController sc;

    public AccountCustomEditExtension(ApexPages.StandardController stdController) {
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
        flag = true;
    }    

    public void changeFlag(){
        flag = !flag;
    } 
    
    public void customSave(){
        if( ! String.isBlank(account.name) && account.name != null ){
            changeFlag();
            sc.save();
           
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter account name, now it is '));     
            setAccount(account);
        } 

        //return null;
    }
    
    public PageReference customCancel(){
        sc.reset();
        this.account = (Account)sc.getRecord();

        changeFlag();
        return null;
    }  
}