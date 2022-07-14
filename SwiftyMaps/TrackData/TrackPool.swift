/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

typealias TrackList = Array<TrackData>

class TrackPool{
    
    static var storeKey = "tracks"
    
    static func load(){
        if let trackList : TrackList = DataController.shared.load(forKey: TrackPool.storeKey){
            tracks = trackList
        }
        else{
            // try from older version
            var trackList = TrackList()
            for loc in LocationPool.locations{
                for track in loc.tracks{
                    trackList.append(track)
                }
            }
            tracks = trackList
            save()
        }
    }
    
    static var tracks : TrackList = TrackList()
    
    static var activeTrack : TrackData? = nil
    static var isTracking : Bool{
        activeTrack != nil
    }
    static var isPausing : Bool = false;
    
    static private var _lock = DispatchSemaphore(value: 1)
    
    static var size : Int{
        tracks.count
    }
    
    static func track(at idx: Int) -> TrackData?{
        tracks[idx]
    }
    
    static func addTrack(track: TrackData){
        _lock.wait()
        defer{_lock.signal()}
        tracks.append(track)
    }
    
    static func deleteTrack(_ track: TrackData){
        _lock.wait()
        defer{_lock.signal()}
        for idx in 0..<tracks.count{
            if tracks[idx] == track{
                tracks.remove(at: idx)
                return
            }
        }
    }
    
    static func deleteAllTracks(){
        _lock.wait()
        defer{_lock.signal()}
        tracks.removeAll()
    }
    
    static func save(){
        _lock.wait()
        defer{_lock.signal()}
        DataController.shared.save(forKey: TrackPool.storeKey, value: tracks)
    }
    
    static func startTracking(){
        if !isTracking, let position = LocationService.shared.lastPosition{
            activeTrack = TrackData()
            activeTrack!.trackpoints.append(position)
        }
        isPausing = false
    }
    
    static func updateTrack(with position: Position){
        if let track = activeTrack{
            track.updateTrack(position)
        }
    }
    
    static func pauseTracking(){
        if let track = activeTrack{
            track.startPause()
            isPausing = true
        }
    }
    
    static func resumeTracking(){
        if let track = activeTrack{
            track.endPause()
            isPausing = false
        }
    }
    
    static func cancelTracking(){
        if activeTrack != nil{
            isPausing = false
            activeTrack = nil
        }
    }
    
    static func saveTrack(name: String){
        if let track = activeTrack{
            track.name = name
            isPausing = false
            tracks.append(track)
            activeTrack = nil
            isPausing = false
            save()
        }
    }
    
}
