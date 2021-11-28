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
    
    private var array : [Location]
    
    private var lock = DispatchSemaphore(value: 1)
    
    var size : Int{
        get{
            array.count
        }
    }
    
    init(){
        array = [Location]()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        array = try values.decodeIfPresent([Location].self, forKey: .locations) ?? [Location]()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(array, forKey: .locations)
    }
    
    func location(at idx: Int) -> Location?{
        array[idx]
    }
    
    @discardableResult
    func addLocation(coordinate: CLLocationCoordinate2D) -> Location{
        lock.wait()
        defer{lock.signal()}
        let location = Location(coordinate: coordinate)
        array.append(location)
        return location
    }
    
    func deleteLocation(_ location: Location){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<array.count{
            if array[idx] == location{
                location.deleteAllPhotos()
                array.remove(at: idx)
                return
            }
        }
    }
    
    func deleteAllLocations(){
        //todo
        array.removeAll()
    }
    
    func locationNextTo(coordinate: CLLocationCoordinate2D, maxDistance: CLLocationDistance) -> Location?{
        var distance : CLLocationDistance = Double.infinity
        var nextLocation : Location? = nil
        for location in array{
            let dist = location.cllocation.coordinate.distance(to: coordinate)
            if dist<maxDistance && dist<distance{
                distance = dist
                nextLocation = location
            }
        }
        return nextLocation
    }
    
    func locationsInPlanetRect(_ rect: CGRect) -> [Location]{
        var result = [Location]()
        for location in array{
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
