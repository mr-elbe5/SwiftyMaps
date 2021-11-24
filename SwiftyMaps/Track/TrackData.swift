//
//  TrackData.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation
import UIKit

class TrackData : Hashable, Codable{
    
    static func == (lhs: TrackData, rhs: TrackData) -> Bool {
        lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case description
        case startLocation
        case trackpoints
        case distance
        case upDistance
        case downDistance
    }
    
    var id : UUID
    var startTime : Date
    var endTime : Date
    var description : String
    var startLocation : Location
    var trackpoints : Array<TrackPoint>
    var distance : CGFloat
    var upDistance : CGFloat
    var downDistance : CGFloat
    
    var duration : TimeInterval{
        get{
            startTime.distance(to: endTime)
        }
    }
    
    init(location: CLLocation){
        id = UUID()
        description = ""
        startLocation = Location(coordinate: location.coordinate)
        startTime = Date()
        endTime = Date()
        trackpoints = Array<TrackPoint>()
        distance = 0
        upDistance = 0
        downDistance = 0
        trackpoints.append(TrackPoint(location: location))
        LocationService.shared.getPlacemarkInfo(for: startLocation)
    }
    
    // locations must not be empty!
    init(locations: [CLLocation]){
        id = UUID()
        description = ""
        let first = locations.first ?? CLLocation()
        startLocation = Location(coordinate: first.coordinate)
        startTime = Date()
        endTime = Date()
        trackpoints = Array<TrackPoint>()
        distance = 0
        upDistance = 0
        downDistance = 0
        for loc in locations{
            trackpoints.append(TrackPoint(location: loc))
        }
        LocationService.shared.getPlacemarkInfo(for: startLocation)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        startTime = try values.decodeIfPresent(Date.self, forKey: .startTime) ?? Date()
        endTime = try values.decodeIfPresent(Date.self, forKey: .endTime) ?? Date()
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        startLocation = try values.decodeIfPresent(Location.self, forKey: .startLocation) ?? Location()
        trackpoints = try values.decodeIfPresent(Array<TrackPoint>.self, forKey: .trackpoints) ?? Array<TrackPoint>()
        distance = try values.decodeIfPresent(CGFloat.self, forKey: .distance) ?? 0
        upDistance = try values.decodeIfPresent(CGFloat.self, forKey: .upDistance) ?? 0
        downDistance = try values.decodeIfPresent(CGFloat.self, forKey: .downDistance) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(description, forKey: .description)
        try container.encode(startLocation, forKey: .startLocation)
        try container.encode(trackpoints, forKey: .trackpoints)
        try container.encode(distance, forKey: .distance)
        try container.encode(upDistance, forKey: .upDistance)
        try container.encode(downDistance, forKey: .downDistance)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updateTrack(_ location: CLLocation){
        let lastTP = trackpoints.last
        if let tp = lastTP{
            if tp.coordinate.closeTo(location.coordinate, maxDistance: 10){
                print("too close")
                return
            }
            if tp.location.timestamp.distance(to: location.timestamp) < 2{
                print("too soon")
                return
            }
        }
        print("adding trackpoint")
        trackpoints.append(TrackPoint(location: location))
        if let lastLoc = lastTP?.location{
            distance += MapController.distanceBetween(coord1: lastLoc.coordinate, coord2: location.coordinate)
            let vDist = location.altitude - lastLoc.altitude
            if vDist > 0{
                upDistance += vDist
            }
            else{
                //invert negative
                downDistance -= vDist
            }
            endTime = location.timestamp
        }
    }
    
    func dump(){
        print(description)
        for tp in trackpoints{
            print("coord: \(tp.coordinateString), altitude: \(tp.location.altitude), time: \(tp.location.timestamp)")
        }
    }
    
}

