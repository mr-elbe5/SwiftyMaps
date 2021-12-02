/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class Locations{
    
    static private var list : LocationList = LocationList.load()
    
    static private var lock = DispatchSemaphore(value: 1)
    
    static var size : Int{
        get{
            list.count
        }
    }
    
    static func location(at idx: Int) -> Location?{
        list[idx]
    }
    
    @discardableResult
    static func addLocation(coordinate: CLLocationCoordinate2D) -> Location{
        lock.wait()
        defer{lock.signal()}
        let location = Location(coordinate: coordinate)
        list.append(location)
        return location
    }
    
    static func deleteLocation(_ location: Location){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<list.count{
            if list[idx] == location{
                location.deleteAllPhotos()
                list.remove(at: idx)
                return
            }
        }
    }
    
    static func deleteAllLocations(){
        //todo
        list.removeAll()
    }
    
    static func locationNextTo(coordinate: CLLocationCoordinate2D, maxDistance: CLLocationDistance) -> Location?{
        var distance : CLLocationDistance = Double.infinity
        var nextLocation : Location? = nil
        for location in list{
            let dist = location.cllocation.coordinate.distance(to: coordinate)
            if dist<maxDistance && dist<distance{
                distance = dist
                nextLocation = location
            }
        }
        return nextLocation
    }
    
    static func locationsInPlanetRect(_ rect: CGRect) -> [Location]{
        var result = [Location]()
        for location in list{
            if location.planetPosition.x >= rect.minX && location.planetPosition.x < rect.minX + rect.width && location.planetPosition.y >= rect.minY && location.planetPosition.y < rect.minY + rect.height{
                result.append(location)
                //print("found location at \(location.planetPosition) in \(rect)")
            }
        }
        return result
    }
    
    static func save(){
        lock.wait()
        defer{lock.signal()}
        LocationList.save(list)
    }
    
}
