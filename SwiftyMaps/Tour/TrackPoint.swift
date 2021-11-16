//
//  TrackPoint.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation
import UIKit

class TrackPoint : Hashable, Codable{
    
    static func == (lhs: TrackPoint, rhs: TrackPoint) -> Bool {
        lhs.location.coordinate == rhs.location.coordinate
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case timestamp
    }
    
    var location : CLLocation
    
    var coordinate : CLLocationCoordinate2D{
        location.coordinate
    }
    
    var coordinateString : String{
        get{
            let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
            let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
            return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
        }
    }
    
    init(){
        location = CLLocation()
    }
    
    init(location: CLLocation){
        self.location = location
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        let altitude = try values.decodeIfPresent(Double.self, forKey: .altitude) ?? 0
        let timestamp = try values.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
        location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location.coordinate.latitude, forKey: .latitude)
        try container.encode(location.coordinate.longitude, forKey: .longitude)
        try container.encode(location.altitude, forKey: .altitude)
        try container.encode(location.timestamp, forKey: .timestamp)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
}
