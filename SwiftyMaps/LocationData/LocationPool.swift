/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

typealias LocationList = Array<LocationData>

class LocationPool{
    
    static var storeKey = "locations"
    
    static func load(){
        if let locationList : LocationList = DataController.shared.load(forKey: LocationPool.storeKey){
            locations = locationList
        }
    }
    
    static var locations =  LocationList()
    
    static private var _lock = DispatchSemaphore(value: 1)
    
    static var size : Int{
        locations.count
    }
    
    static func location(at idx: Int) -> LocationData?{
        locations[idx]
    }
    
    @discardableResult
    static func addLocation(coordinate: CLLocationCoordinate2D) -> LocationData{
        _lock.wait()
        defer{_lock.signal()}
        let location = LocationData(coordinate: coordinate)
        locations.append(location)
        return location
    }
    
    static func deleteLocation(_ location: LocationData){
        _lock.wait()
        defer{_lock.signal()}
        for idx in 0..<locations.count{
            if locations[idx] == location{
                location.deleteAllPhotos()
                locations.remove(at: idx)
                return
            }
        }
    }
    
    static func deleteAllLocations(){
        _lock.wait()
        defer{_lock.signal()}
        for idx in 0..<locations.count{
            locations[idx].deleteAllPhotos()
        }
        locations.removeAll()
    }
    
    static func locationNextTo(coordinate: CLLocationCoordinate2D, maxDistance: CLLocationDistance) -> LocationData?{
        var distance : CLLocationDistance = Double.infinity
        var nextLocation : LocationData? = nil
        for location in locations{
            let dist = location.cllocation.coordinate.distance(to: coordinate)
            if dist<maxDistance && dist<distance{
                distance = dist
                nextLocation = location
            }
        }
        return nextLocation
    }
    
    static func save(){
        _lock.wait()
        defer{_lock.signal()}
        DataController.shared.save(forKey: LocationPool.storeKey, value: locations)
    }
    
}
