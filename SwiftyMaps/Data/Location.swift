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
        case hasPlacemark
        case name
        case street
        case zipCode
        case city
        case country
    }
    
    var coordinate : CLLocationCoordinate2D
    var planetPosition : CGPoint
    var hasPlacemark : Bool
    var name : String = ""
    var street : String = ""
    var zipCode : String = ""
    var city : String = ""
    var country : String = ""
    
    var cllocation : CLLocation{
        CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    var locationString : String{
        var s = name
        if !s.isEmpty{
            s += " - "
        }
        if !street.isEmpty{
            s += street
            s += ", "
        }
        if !zipCode.isEmpty{
            s += zipCode
            s += " "
        }
        if !city.isEmpty{
            s += city
        }
        return s
    }
    
    var coordinateString : String{
        get{
            let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
            let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
            return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
        }
    }
    
    init(){
        coordinate = CLLocationCoordinate2D()
        planetPosition = CGPoint()
        hasPlacemark = false
    }
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        planetPosition = MapCalculator.planetPointFromCoordinate(coordinate: coordinate)
        hasPlacemark = false
        LocationService.shared.getPlacemarkInfo(for: self)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        hasPlacemark = try values.decodeIfPresent(Bool.self, forKey: .hasPlacemark) ?? false
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        street = try values.decodeIfPresent(String.self, forKey: .street) ?? ""
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode) ?? ""
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        planetPosition = MapCalculator.planetPointFromCoordinate(coordinate: coordinate)
        if !hasPlacemark{
            LocationService.shared.getPlacemarkInfo(for: self)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(hasPlacemark, forKey: .hasPlacemark)
        try container.encode(name, forKey: .name)
        try container.encode(street, forKey: .street)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
    }
    
    func addPlacemarkInfo(placemark: CLPlacemark){
        street = placemark.thoroughfare ?? ""
        if let number = placemark.subThoroughfare{
            if !street.isEmpty{
                street += " "
            }
            street += number
        }
        if let name = placemark.name{
            self.name = (name == street) ? "" : name
        }
        zipCode = placemark.postalCode ?? ""
        city = placemark.locality ?? ""
        country = placemark.country ?? ""
        print("name = \(name)")
        print("street = \(street)")
        print("zipCode = \(zipCode)")
        print("city = \(city)")
        print("country = \(country)")
        print("description = \(locationString)")
        hasPlacemark = true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
}
