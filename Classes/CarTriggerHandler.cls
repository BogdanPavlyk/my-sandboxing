public with sharing class CarTriggerHandler 
{
    public CarTriggerHandler(){}

    public void onBeforeInsert(List<Car__c> carsToInsert){

      for(Car__c car : carsToInsert){

            if(car.Speed__c < 150){
                car.Category__c = 'Cargo';
            } else if (car.Speed__c >= 150 && car.Speed__c <200){
                car.Category__c = 'Passenger';
            } else if (car.Speed__c >= 200){
                car.Category__c = 'Sport';
            }
            
            System.debug('\n\n ===> carPrice.Category__c: ' + car.Category__c + '\n');
        }

    }
}