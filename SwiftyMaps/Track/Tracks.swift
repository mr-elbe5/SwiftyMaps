//
//  TrackCache.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

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
    var activeTrack : TrackData? = nil
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
        //todo
        if currentTrack != activeTrack{
            currentTrack = nil
        }
        tracks.removeAll()
    }
    
    func save(){
        lock.wait()
        defer{lock.signal()}
        DataController.shared.save(forKey: .tracks, value: self)
    }
    
    func startTracking(){
        if activeTrack == nil{
            guard let location = LocationService.shared.location else {return}
            activeTrack = TrackData(location: location)
            currentTrack = activeTrack
        }
        isTracking = true
    }
    
    func updateCurrentTrack(with location: CLLocation){
        if let track = currentTrack{
            track.updateTrack(location)
        }
    }
    
    func pauseTracking(){
        isTracking = false
    }
    
    func resumeTracking(){
        if activeTrack != nil{
            isTracking = true
        }
    }
    
    func cancelCurrentTrack(){
        if let track = activeTrack{
            isTracking = false
            if currentTrack == track{
                currentTrack = nil
            }
            activeTrack = nil
        }
    }
    
    func saveTrackCurrentTrack(){
        if let track = activeTrack{
            isTracking = false
            addTrack(track)
            save()
            activeTrack = nil
        }
    }
    
}
