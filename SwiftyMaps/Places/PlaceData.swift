/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol PlaceDelegate{
    func descriptionChanged(place: PlaceData)
}

class PlaceData : Hashable, Codable{
    
    static func == (lhs: PlaceData, rhs: PlaceData) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case horizontalAccuracy
        case verticalAccuracy
        case altitude
        case timestamp
        case description
        case photos
    }
    
    var id : UUID
    var location : CLLocation
    var planetPosition : CGPoint
    var description : String
    var photos : Array<PlaceImage>
    
    var coordinate : CLLocationCoordinate2D{
        location.coordinate
    }
    
    var altitude: CLLocationDistance{
        location.altitude
    }
    
    var timestamp : Date{
        location.timestamp
    }
    
    var coordinateString : String{
        get{
            let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
            let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
            return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
        }
    }
    
    var delegate: PlaceDelegate? = nil
    
    init(location: CLLocation){
        id = UUID()
        self.location = location
        description = ""
        photos = Array<PlaceImage>()
        planetPosition = MapCalculator.pointInScaledSize(coordinate: location.coordinate, scaledSize: MapStatics.planetSize)
        LocationService.shared.getLocationDescription(coordinate: coordinate){ description in
            self.description = description
            DispatchQueue.main.async {
                self.delegate?.descriptionChanged(place: self)
            }
        }
        
    }
    
    convenience init(_ coordinate: CLLocationCoordinate2D, altitude : CLLocationDistance = 0, timestamp: Date = Date()){
        let location = CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: timestamp)
        self.init(location: location)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        let horizontalAccuracy = try values.decodeIfPresent(Double.self, forKey: .horizontalAccuracy) ?? 0
        let verticalAccuracy = try values.decodeIfPresent(Double.self, forKey: .verticalAccuracy) ?? 0
        let altitude = try values.decodeIfPresent(Double.self, forKey: .altitude) ?? 0
        let timestamp = try values.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
        location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, timestamp: timestamp)
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        photos = try values.decodeIfPresent(Array<PlaceImage>.self, forKey: .photos) ?? Array<PlaceImage>()
        planetPosition = MapCalculator.pointInScaledSize(coordinate: location.coordinate, scaledSize: MapStatics.planetSize)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(location.horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(location.verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(location.altitude, forKey: .altitude)
        try container.encode(location.timestamp, forKey: .timestamp)
        try container.encode(description, forKey: .description)
        try container.encode(photos, forKey: .photos)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
