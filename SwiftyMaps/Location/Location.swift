//
//  Location.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 12.11.21.
//

import Foundation
import CoreLocation
import UIKit

class Location : Hashable, Codable{
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    var coordinate : CLLocationCoordinate2D
    var planetPosition : CGPoint
    
    var location : CLLocation{
        CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    var coordinateString : String{
        get{
            let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
            let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
            return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
        }
    }
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        planetPosition = MapCalculator.planetPointFromCoordinate(coordinate: coordinate)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        planetPosition = MapCalculator.planetPointFromCoordinate(coordinate: coordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
}
