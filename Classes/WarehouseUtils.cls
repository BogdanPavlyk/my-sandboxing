global with sharing class WarehouseUtils {

    public WarehouseUtils(ApexPages.StandardSetController stdSetController) { }

    @RemoteAction
    global static List<Warehouse__c> findNearbyWarehouses(String lat, String lon){

        // If geolocation parameters are invalid, use San Francisco
        if(String.isBlank(lat) || String.isBlank(lon)) {
            lat = '37.793731';
            lon = '-122.395002';
        }

        //Initialize results to an empty list
        List<Warehouse__c> results = new List<Warehouse__c>();

        String queryString =
            'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, ' +
                'Street_Address__c, Phone__c, City__c ' +
            'FROM Warehouse__c ' +
            'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 20 ' +
            'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
            'LIMIT 10';

        // Run the query
        results = database.Query(queryString);
        
        return(results);
    }
}