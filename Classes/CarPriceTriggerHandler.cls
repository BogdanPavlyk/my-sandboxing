public with sharing class CarPriceTriggerHandler{

    public CarPriceTriggerHandler(){}

    public void onBeforeInsert(List<Car_Price__c> carPricesToInsert){

      for(Car_Price__c carPrice : carPricesToInsert){

            if(carPrice.Car_Owner__c == null){
                carPrice.Status__c = 'New';
            } else {
                carPrice.Status__c = 'Sold';
            }
            
            System.debug('\n\n ===> carPrice.Status__c: ' + carPrice.Status__c + '\n');
        }

    }

    public void onBeforeUpdate(List<Car_Price__c> carPricesToUpdate, Map<Id, Car_Price__c> oldCarPrices){

        for(Car_Price__c carPrice : carPricesToUpdate){
            if(carPrice.Car_Owner__c != oldCarPrices.get(carPrice.Id).Car_Owner__c){

                if(carPrice.Car_Owner__c == null){
                   carPrice.Car_Owner__c = oldCarPrices.get(carPrice.Id).Car_Owner__c;
                } else {

                carPrice.Status__c = 'Second Hand';
                System.debug('\n\n ===> NEW carPrice.Status__c: ' + carPrice.Status__c + '\n');
                }
            }
        }
    }

    public void onAfterInsert(List<Car_Price__c> carPricesToUpdate, Map<Id, Car_Price__c> newCarPrices){

        this.updateCarOwnersOnCarsByCarPrices(carPricesToUpdate, newCarPrices, false);         
    }
    
    public void onAfterUpdate(List<Car_Price__c> carPricesToUpdate, Map<Id, Car_Price__c> oldCarPrices){

        this.updateCarOwnersOnCarsByCarPrices(carPricesToUpdate, oldCarPrices, true);
    }


    //Helpers
    private void updateCarOwnersOnCarsByCarPrices(List<Car_Price__c> carPricesToUpdate, Map<Id, Car_Price__c> carPricesMap,
                                                                                                Boolean isUpdate){

        Map<Id, Car_Price__c> getCarPricesWithCarsById = this.getCarPricesWithCarsByIdWithIds(carPricesMap.keySet());
        List<Car__c> carsToUpdate = new List<Car__c>();

        for(Car_Price__c carPrice : carPricesToUpdate){

            Id carOwner;

            if( isUpdate ){
            carOwner = carPricesMap.get(carPrice.Id).Car_Owner__c;
            } else {
            carOwner = null;
            }

            System.debug('carOwner = ' + carOwner + ' carPrice.Car_Owner__c = ' + carPrice.Car_Owner__c);

            if(carPrice.Car_Owner__c != carOwner){

                Car__c car = getCarPricesWithCarsById.get(carPrice.Id).Model__r;
                car.Car_Owner__c = carPrice.Car_Owner__c;

                carsToUpdate.add(car);             
            }
        } 

        if(carsToUpdate.size() > 0){
            update carsToUpdate;
        } 
    }

    private Set<Id> getCarsIds(List<Car_Price__c> carPrices){
        Set<Id> carIds = new Set<Id>();

        for(Car_Price__c carPrice : carPrices){
            carIds.add(carPrice.Model__c);
        }

        return carIds;
    }

    // SOQL Helper
    private Map<Id, Car__c> getCarsById(Set<Id> carIds) {
        return new Map<Id, Car__c>([
            SELECT Id, Car_Owner__c
            FROM Car__c
            WHERE Id = :carIds
        ]);
    }

    private Map<Id, Car_Price__c> getCarPricesWithCarsByIdWithIds(Set<Id> carPricesIds) {
        return new Map<Id, Car_Price__c>([
            SELECT Id, Model__r.Id, Model__r.Car_Owner__c
            FROM Car_Price__c
            WHERE Id = :carPricesIds
        ]);
    }
}