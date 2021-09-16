//
//  Location.swift
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Location: Identifiable, Codable{
    
    static var initialRadius : Double = 10000
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case latitudeSpan
        case longitudeSpan
        case altitude
    }
    
    var coordinate: CLLocationCoordinate2D
    var latitudeSpan: Double
    var longitudeSpan: Double
    var altitude: Double
    
    init(){
        coordinate = CLLocationCoordinate2D()
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: Location.initialRadius, longitudinalMeters: Location.initialRadius)
        latitudeSpan = region.span.latitudeDelta
        longitudeSpan = region.span.longitudeDelta
        altitude = 0.0
    }
    
    init(_ location: CLLocation){
        self.coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: Location.initialRadius, longitudinalMeters: Location.initialRadius)
        latitudeSpan = region.span.latitudeDelta
        longitudeSpan = region.span.longitudeDelta
        self.altitude = location.altitude
    }
    
    init(_ coordinate: CLLocationCoordinate2D, latitudeSpan: Double, longitudeSpan : Double){
        self.coordinate = coordinate
        self.latitudeSpan = latitudeSpan
        self.longitudeSpan = longitudeSpan
        altitude = 0.0
    }
    
    var asString : String{
        get{
            let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
            let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
            return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        latitudeSpan = try values.decodeIfPresent(Double.self, forKey: .latitudeSpan) ?? 0
        longitudeSpan = try values.decodeIfPresent(Double.self, forKey: .longitudeSpan) ?? 0
        altitude = try values.decode(Double.self, forKey: .altitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(latitudeSpan, forKey: .latitudeSpan)
        try container.encode(longitudeSpan, forKey: .longitudeSpan)
        try container.encode(altitude, forKey: .altitude)
    }
    
}
