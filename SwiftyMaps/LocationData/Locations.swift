/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class Locations{
    
    static private var _list : LocationList = LocationList.load()
    
    static private var _lock = DispatchSemaphore(value: 1)
    
    static var size : Int{
        _list.count
    }
    
    static func location(at idx: Int) -> Location?{
        _list[idx]
    }
    
    static var list : LocationList{
        _list
    }
    
    @discardableResult
    static func addLocation(coordinate: CLLocationCoordinate2D) -> Location{
        _lock.wait()
        defer{_lock.signal()}
        let location = Location(coordinate: coordinate)
        _list.append(location)
        return location
    }
    
    static func deleteLocation(_ location: Location){
        _lock.wait()
        defer{_lock.signal()}
        for idx in 0..<_list.count{
            if _list[idx] == location{
                location.deleteAllPhotos()
                _list.remove(at: idx)
                return
            }
        }
    }
    
    static func deleteAllLocations(){
        _lock.wait()
        defer{_lock.signal()}
        for idx in 0..<_list.count{
            _list[idx].deleteAllPhotos()
        }
        _list.removeAll()
    }
    
    static func locationNextTo(coordinate: CLLocationCoordinate2D, maxDistance: CLLocationDistance) -> Location?{
        var distance : CLLocationDistance = Double.infinity
        var nextLocation : Location? = nil
        for location in _list{
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
        LocationList.save(_list)
    }
    
    static func getAllTracks() -> TrackList{
        var tracks = TrackList()
        for loc in _list{
            for track in loc.tracks{
                tracks.append(track)
            }
        }
        return tracks
    }
    
    static func deleteTrack(track: TrackData){
        _lock.wait()
        defer{_lock.signal()}
        for idx in 0..<list.count{
            if list[idx].tracks.contains(track){
                list[idx].tracks.remove(track)
                return
            }
        }
    }
    
    static func deleteAllTracks(){
        _lock.wait()
        defer{_lock.signal()}
        for loc in _list{
            loc.tracks.removeAll()
        }
    }
    
}
