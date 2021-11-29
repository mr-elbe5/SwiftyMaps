/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class Tracks: Codable{
    
    // instance

    static var instance : Tracks!
    
    static var storeKey = "tracks"
    
    static func loadInstance(){
        if let cache : Tracks = DataController.shared.load(forKey: .tracks){
            instance = cache
        }
        else{
            instance = Tracks()
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case tracks
    }
    
    var tracks : [TrackData]
    
    var currentTrack : TrackData? = nil
    var isTracking : Bool = false
    
    private var lock = DispatchSemaphore(value: 1)
    
    init(){
        tracks = [TrackData]()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tracks = try values.decodeIfPresent([TrackData].self, forKey: .tracks) ?? [TrackData]()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tracks, forKey: .tracks)
    }
    
    func addTrack(_ track: TrackData){
        lock.wait()
        defer{lock.signal()}
        tracks.append(track)
    }
    
    func deleteTrack(_ track: TrackData){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<tracks.count{
            if tracks[idx] == track{
                tracks.remove(at: idx)
                return
            }
        }
    }
    
    func deleteAllTracks(){
        tracks.removeAll()
    }
    
    func save(){
        lock.wait()
        defer{lock.signal()}
        DataController.shared.save(forKey: .tracks, value: self)
    }
    
    func startTracking(){
        if currentTrack == nil{
            guard let location = LocationService.shared.lastLocation else {return}
            currentTrack = TrackData(location: location)
        }
        isTracking = true
    }
    
    func updateCurrentTrack(with location: CLLocation){
        if let track = currentTrack{
            track.updateTrack(location)
        }
    }
    
    func pauseTracking(){
        if let track = currentTrack{
            track.pauseTracking()
            isTracking = false
        }
    }
    
    func resumeTracking(){
        if let track = currentTrack{
            track.resumeTracking()
            isTracking = true
        }
    }
    
    func cancelCurrentTrack(){
        if currentTrack != nil{
            isTracking = false
            currentTrack = nil
        }
    }
    
    func saveTrackCurrentTrack(){
        if let track = currentTrack{
            isTracking = false
            addTrack(track)
            save()
            currentTrack = nil
        }
    }
    
}
