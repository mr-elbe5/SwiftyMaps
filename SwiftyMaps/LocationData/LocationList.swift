/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

typealias LocationList = Array<Location>
    
extension LocationList{
    
    static var storeKey = "locations"
    
    static func load() -> LocationList{
        if let locations : LocationList = DataController.shared.load(forKey: LocationList.storeKey){
            return locations
        }
        else{
            return LocationList()
        }
    }
    
    static func save(_ list: LocationList){
        DataController.shared.save(forKey: LocationList.storeKey, value: list)
    }
    
}

