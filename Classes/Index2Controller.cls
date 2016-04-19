public class Index2Controller {

    public Id currentProduct { get; set; }
    public Id currentOrder_product { get; set; }
    public Decimal totalPrice;
    public Invoice__c invoice { get; set; }
    public String client_name { get; set; }
    public String phone { get; set; }
    public String email { get; set; }
    Set<Id> ids = new Set<Id>();
    List<String> categories = new List<String> {'Notebook', 'Smartphone', 'Monitor'};
    List<WrapperMerchandise> orders1;
    List<Line_Item__c> lineitems = new List<Line_Item__c>();
    List<Merchandise__c> orders;
    List<Merchandise__c> products = new List<Merchandise__c>([
                        SELECT Id, Name, Category__c, Price__c, image__c, Quantity__c FROM Merchandise__c
                        ORDER BY Price__c DESC LIMIT 10]);
    {
    products.sort();
    }
    
    
     public Decimal getTotalPrice(){
        Decimal tmp = 0;
        orders1 = getOrders1();
        for(WrapperMerchandise wm : orders1){
            tmp += wm.getPrice();
        }
        return tmp;
    }
    
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
        products.add([
                        SELECT Id, Name, Category__c, Price__c, image__c, Quantity__c FROM Merchandise__c
                        WHERE Id =: currentOrder_product
            ]);
    }
    
    public List<Merchandise__c> getOrders(){
        if(lineitems != null){
        orders = new List<Merchandise__c>([SELECT Id, Name, Price__c, Quantity__c FROM Merchandise__c WHERE Id IN :ids]);

    }
        return orders; 

    }
    
    public List<WrapperMerchandise> getOrders1(){
    
        List<WrapperMerchandise> wm = new List<WrapperMerchandise>();
        if(lineitems != null && lineitems.size() > 0){
        orders = getOrders();
        System.debug(orders);
        for(Integer i=0; i< orders.size(); i++){
            wm.add(new WrapperMerchandise( orders.get(i) ));
        }
        }
        
        return wm; 

    }

    public void saveInvoice(){
            invoice.phone__c = phone; 
            invoice.client_name__c = client_name;   
            invoice.email__c = email;
    }

    public void makeOrder(){
        if(orders != null){
            saveInvoice();
            upsert invoice;
            insert lineitems;
            invoice = null;
            lineitems = new List<Line_Item__c>();
            ids=null;
            orders = new List<Merchandise__c>();
            products = new List<Merchandise__c>([
                        SELECT Id, Name, Category__c, Price__c, image__c, Quantity__c FROM Merchandise__c
                        ORDER BY Price__c DESC LIMIT 10]);
        }
        
    }
    
    public void cancelOrder(){

        delete(invoice);
        invoice = null;
        lineitems = new List<Line_Item__c>();
        ids=null;
        orders = new List<Merchandise__c>();
        products = new List<Merchandise__c>([
                        SELECT Id, Name, Category__c, Price__c, image__c, Quantity__c FROM Merchandise__c
                        ORDER BY Price__c DESC LIMIT 10]);
            products.sort();
        
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

    public List<String> getCategories(){
        return categories;        
    }
    
    public PageReference getValidate(){
    orders1 = getOrders1();
    for(WrapperMerchandise wm : orders1){
            if(wm.orderQuantity < 1){

    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ' < 1');
    apexpages.addmessage(myMsg);
    break;
    

    }
            
    }
    return null;
    }
    
    public void rerenderCart(){
    
    }
   
    
    
    
   public class WrapperMerchandise{
    
        public Merchandise__c merchandise { get; set; }
        public Integer orderQuantity { get; set; }
        
        {
        orderQuantity = 1;
        }
        
        public WrapperMerchandise(Merchandise__c merchandise){
            this.merchandise = merchandise;
        }
        
        public Integer getOrderQuantity(){
            return orderQuantity;
        }
        
        public Decimal getPrice(){
            return merchandise.Price__c * orderQuantity;
        }
        
    }

}