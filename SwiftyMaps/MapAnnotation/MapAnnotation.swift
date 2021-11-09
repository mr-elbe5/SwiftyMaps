/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol MapAnnotationDelegate{
    func descriptionChanged(annotation: MapAnnotation)
}

class MapAnnotation : Hashable, Codable{
    
    static func == (lhs: MapAnnotation, rhs: MapAnnotation) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case description
        case timestamp
        case photos
    }
    
    var id : UUID
    var coordinate : CLLocationCoordinate2D
    var planetPosition : CGPoint
    var description : String
    var timestamp : Date
    var photos : Array<MapAnnotationPhoto>
    
    var delegate: MapAnnotationDelegate? = nil
    
    init(coordinate: CLLocationCoordinate2D){
        id = UUID()
        self.coordinate = coordinate
        description = ""
        timestamp = Date()
        planetPosition = MapCalculator.pointInScaledSize(coordinate: coordinate, scaledSize: MapStatics.planetSize)
        photos = Array<MapAnnotationPhoto>()
        LocationService.shared.getLocationDescription(coordinate: coordinate){ description in
            self.description = description
            DispatchQueue.main.async {
                self.delegate?.descriptionChanged(annotation: self)
            }
        }
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        if let latidude = try values.decodeIfPresent(Double.self, forKey: .latitude),
           let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude){
            coordinate = CLLocationCoordinate2D(latitude: latidude, longitude: longitude)
        }
        else{
            coordinate = CLLocationCoordinate2D()
        }
        planetPosition = MapCalculator.pointInScaledSize(coordinate: coordinate, scaledSize: MapStatics.planetSize)
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        timestamp = try values.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
        photos = try values.decodeIfPresent(Array<MapAnnotationPhoto>.self, forKey: .photos) ?? Array<MapAnnotationPhoto>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(description, forKey: .description)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(photos, forKey: .photos)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
