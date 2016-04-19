public with sharing class IndexTestController {

    List<Merchandise__c> products;
    List<String> categories = new List<String> {'Notebook', 'Smartphone', 'Monitor'};

    public List<Merchandise__c> getProducts(){
        String currentCategory = Apexpages.currentPage().getParameters().get('category');
        
        if(currentCategory != null){

            products = new List<Merchandise__c>([
                        SELECT Id, Name, Category__c FROM Merchandise__c
                        WHERE Category__c =: currentCategory
            ]);
        } else if(products == null){
                 
            products = new List<Merchandise__c>([
                        SELECT Id, Name, Category__c FROM Merchandise__c
                        
            ]);
        }
        
        return products;
    }

    public List<String> getCategories(){

        return categories;
    }

}