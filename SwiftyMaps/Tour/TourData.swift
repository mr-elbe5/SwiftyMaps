//
//  TourData.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation
import UIKit

class TourData : Hashable, Codable{
    
    static var activeTour : TourData? = nil
    
    static func == (lhs: TourData, rhs: TourData) -> Bool {
        lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case trackpoints
    }
    
    var id : UUID
    var description : String
    var trackpoints : Array<TrackPoint>
    
    init(){
        id = UUID()
        description = ""
        trackpoints = Array<TrackPoint>()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        trackpoints = try values.decodeIfPresent(Array<TrackPoint>.self, forKey: .trackpoints) ?? Array<TrackPoint>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(description, forKey: .description)
        try container.encode(trackpoints, forKey: .trackpoints)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updateTrack(_ location: CLLocation){
        if let lastTP = trackpoints.last{
            if lastTP.coordinate.closeTo(location.coordinate, maxDistance: 10){
                print("too close")
                return
            }
        }
        print("adding trackpoint")
        trackpoints.append(TrackPoint(location: location))
    }
    
    func dump(){
        print(description)
        for tp in trackpoints{
            print("coord: \(tp.coordinateString), altitude: \(tp.location.altitude), time: \(tp.location.timestamp)")
        }
    }
    
}

