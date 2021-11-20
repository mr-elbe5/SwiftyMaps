//
//  TrackCache.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation
import UIKit

class TrackController: Codable{
    
    static var storeKey = "tracks"
    
    static var currentTrack : TrackData? = nil
    
    static var isTracking : Bool = false
    
    static var instance : TrackController!
    
    static func loadInstance(){
        if let cache : TrackController = DataController.shared.load(forKey: .tracks){
            instance = cache
        }
        else{
            instance = TrackController()
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case tracks
    }
    
    var tracks : [TrackData]
    
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
    
    @discardableResult
    func addTrack() -> TrackData{
        lock.wait()
        defer{lock.signal()}
        let track = TrackData()
        tracks.append(track)
        return track
    }
    
    func removeTrack(_ track: TrackData){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<tracks.count{
            if tracks[idx] == track{
                tracks.remove(at: idx)
                return
            }
        }
    }
    
    /*func tracksInPlanetRect(_ rect: CGRect) -> [TrackData]{
        var result = [TrackData]()
        for track in tracks{
            //todo
        }
        return result
    }*/
    
    func save(){
        lock.wait()
        defer{lock.signal()}
        DataController.shared.save(forKey: .tracks, value: self)
    }
    
}
