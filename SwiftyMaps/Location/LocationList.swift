/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

typealias LocationList = Array<Location>
    
extension LocationList{
    
    static func load() -> LocationList{
        if let locations : LocationList = DataController.shared.load(forKey: .locations){
            return locations
        }
        else{
            return LocationList()
        }
    }
    
    static func save(_ list: LocationList){
        DataController.shared.save(forKey: .locations, value: list)
    }
    
}
