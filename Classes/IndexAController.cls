public  class IndexAController {

    List<Line_Item__c> lineitems = new List<Line_Item__c>();
    List<Merchandise__c> orders;
    Set<Id> ids = new Set<Id>();
    public Invoice__c invoice { get; set; }
    public String client_name { get; set; }
    public String phone { get; set; }
    public String email;
    public String getemail(){return email;}
   
    public void setemail(String email)
    {
        this.email = email;
    } 
    
    public PageReference rerenderProducts(){
        return null;
    }
    List<Merchandise__c> products;
    Set<String> categories = new Set<String> { 'Notebook', 'Smartphone', 'Monitor'};
    //= new Set<Merchandise__c>([SELECT Category__c FROM Merchandise__c]);
    public Id currentProduct { get; set; }
    public Id currentOrder_product { get; set; }
    
    public void deleteFromProducts(Id currId){
        for(Integer m1 = 0; m1 < products.size(); m1++){
            if(products.get(m1).Id == currId){
                products.remove(m1);
                break;
            }
        }

    }
    
    public void deleteFromOrder(){
        this.currentOrder_product = Apexpages.currentPage().getParameters().get('currentOrder_product'); 
        for(Integer m = 0; m < orders.size(); m++){
            if(orders.get(m).Id == currentOrder_product){
                orders.remove(m);
                break;
            }
        }
        for(Id i : ids){
            if(i == currentOrder_product){
                ids.remove(i);
                break;
            }
        }
        for(Integer l = 0; l < lineitems.size(); l++){
            if(lineitems.get(l).Merchandise__c == currentOrder_product){
                lineitems.remove(l);
                break;
            }
        }
    }
    //TODO добавить в корзину inputField Quantity, по умолчанию значение 1
    public List<Merchandise__c> getOrders(){
        if(lineitems != null){
        orders = new List<Merchandise__c>([SELECT Id, Name, Price__c FROM Merchandise__c WHERE Id IN :ids]);

    }
        return orders; 

    }

    public void saveInvoice(){
            //invoice = [SELECT Id, Name, Client_name__c, Phone__c, Email__c
            //FROM Invoice__c ORDER BY Invoice__c.ID DESC LIMIT 1];
            
            invoice.phone__c = phone; System.debug(phone);
            invoice.client_name__c = client_name;   System.debug(client_name);
            invoice.email__c = email; System.debug(email);
    }

    public void makeOrder(){
        if(orders != null){
            saveInvoice();
            
            //invoice = [SELECT Id, Name, Client_name__c, Phone__c, Email__c
            //FROM Invoice__c ORDER BY Invoice__c.ID DESC LIMIT 1];            
            //invoice.phone__c = phone; System.debug(phone);
            //invoice.client_name__c = client_name;   System.debug(client_name);
            //setEmail(email);
            //invoice.email__c = email; System.debug(email);
            
            upsert invoice;
            insert lineitems;
            invoice = null;
            lineitems = null;
            ids=null;
            orders = null;

        }
        
    }
    
    public void cancelOrder(){

        delete(invoice);
        invoice = null;
        lineitems = null;
        ids=null;
        orders = null;
        
    }

    

    public void addLineItem(){
        if(invoice == null){
            invoice = new Invoice__c();
            invoice.client_name__c = '';
            invoice.phone__c = '';
            invoice.email__c = '1@2.3';
            insert invoice;
            invoice = [SELECT Id, Name, Client_name__c, Phone__c, Email__c
            FROM Invoice__c ORDER BY Invoice__c.ID DESC LIMIT 1];
        }
        this.currentProduct = Apexpages.currentPage().getParameters().get('currentProduct');
        deleteFromProducts(currentProduct);
        Line_Item__c li = new Line_Item__c();
        li.Merchandise__c = this.currentProduct;
        
        if( ids == null){
            ids = new Set<Id>();
        }
        ids.add(this.currentProduct);

        li.Invoice__c = invoice.Id; 
        if(lineitems == null){
            lineitems = new List<Line_Item__c>();
        }
        li.Name = lineitems.size() + 1 + ''; 
        li.Quantity__c = 1;
        lineitems.add(li);
       
    }
    public List<Line_Item__c>  getLineitems(){
        return lineitems;
    }

    public List<Merchandise__c> getProducts(){
        String currentCategory = Apexpages.currentPage().getParameters().get('category');

        if(currentCategory != null){

            products = new List<Merchandise__c>([
                        SELECT Id, Name, Category__c, Price__c, image__c, Quantity__c FROM Merchandise__c
                        WHERE Category__c =: currentCategory
            ]);
        } 
        return products;
    }

    public Set<String> getCategories(){
        return categories;        
    }

}