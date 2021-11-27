/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class Locations: Codable{
    
    static var storeKey = "locations"
    
    static var instance : Locations!
    
    static func loadInstance(){
        if let cache : Locations = DataController.shared.load(forKey: .locations){
            instance = cache
        }
        else{
            instance = Locations()
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case locations
    }
    
    var locations : [Location]
    
    private var lock = DispatchSemaphore(value: 1)
    
    init(){
        locations = [Location]()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        locations = try values.decodeIfPresent([Location].self, forKey: .locations) ?? [Location]()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(locations, forKey: .locations)
    }
    
    @discardableResult
    func addLocation(coordinate: CLLocationCoordinate2D) -> Location{
        lock.wait()
        defer{lock.signal()}
        let location = Location(coordinate: coordinate)
        locations.append(location)
        return location
    }
    
    func deleteLocation(_ location: Location){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<locations.count{
            if locations[idx] == location{
                location.deleteAllPhotos()
                locations.remove(at: idx)
                return
            }
        }
    }
    
    func deleteAllLocations(){
        //todo
        locations.removeAll()
    }
    
    func locationNextTo(location: CLLocation) -> Location?{
        var distance : CLLocationDistance = Double.infinity
        var nextLocation : Location? = nil
        for location in locations{
            let dist = location.cllocation.distance(from: location.cllocation)
            if dist <= location.cllocation.horizontalAccuracy && dist<distance{
                distance = dist
                nextLocation = location
            }
        }
        return nextLocation
    }
    
    func locationsInPlanetRect(_ rect: CGRect) -> [Location]{
        var result = [Location]()
        for location in locations{
            if location.planetPosition.x >= rect.minX && location.planetPosition.x < rect.minX + rect.width && location.planetPosition.y >= rect.minY && location.planetPosition.y < rect.minY + rect.height{
                result.append(location)
                //print("found location at \(location.planetPosition) in \(rect)")
            }
        }
        return result
    }
    
    func save(){
        lock.wait()
        defer{lock.signal()}
        DataController.shared.save(forKey: .locations, value: self)
    }
    
}
