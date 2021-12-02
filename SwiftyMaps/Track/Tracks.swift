/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class Tracks{
    
    static var list : TrackList = TrackList.load()
    
    static var currentTrack : TrackData? = nil
    static var isTracking : Bool = false
    
    static private var lock = DispatchSemaphore(value: 1)
    
    static func addTrack(_ track: TrackData){
        lock.wait()
        defer{lock.signal()}
        list.append(track)
    }
    
    static func deleteTrack(track: TrackData){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<list.count{
            if list[idx] == track{
                list.remove(at: idx)
                return
            }
        }
    }
    
    static func deleteAllTracks(){
        lock.wait()
        defer{lock.signal()}
        list.removeAll()
    }
    
    static func save(){
        lock.wait()
        defer{lock.signal()}
        TrackList.save(list)
    }
    
    static func startTracking(){
        if currentTrack == nil{
            guard let location = LocationService.shared.lastLocation else {return}
            currentTrack = TrackData(location: location)
        }
        isTracking = true
    }
    
    static func updateCurrentTrack(with location: CLLocation){
        if let track = currentTrack{
            track.updateTrack(location)
        }
    }
    
    static func pauseTracking(){
        if let track = currentTrack{
            track.pauseTracking()
            isTracking = false
        }
    }
    
    static func resumeTracking(){
        if let track = currentTrack{
            track.resumeTracking()
            isTracking = true
        }
    }
    
    static func cancelCurrentTrack(){
        if currentTrack != nil{
            isTracking = false
            currentTrack = nil
        }
    }
    
    static func saveTrackCurrentTrack(){
        if let track = currentTrack{
            isTracking = false
            addTrack(track)
            save()
            currentTrack = nil
        }
    }
    
}
