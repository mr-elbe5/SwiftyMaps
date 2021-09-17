//
//  CodableRegion.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 17.09.21.
//

import Foundation
import MapKit

class CodableRegion : Codable{
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case latitudeDelta
        case longitudeDelta
    }

    var region : MKCoordinateRegion
    
    init(region: MKCoordinateRegion){
        self.region = region
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let latidude = try values.decodeIfPresent(Double.self, forKey: .latitude),
           let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude),
           let latitudeDelta = try values.decodeIfPresent(Double.self, forKey: .latitudeDelta),
           let longitudeDelta = try values.decodeIfPresent(Double.self, forKey: .longitudeDelta){
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latidude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        }
        else{
            region = MKCoordinateRegion()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(region.center.latitude, forKey: .latitude)
        try container.encode(region.center.longitude, forKey: .longitude)
        try container.encode(region.span.latitudeDelta, forKey: .latitudeDelta)
        try container.encode(region.span.longitudeDelta, forKey: .longitudeDelta)
    }
    
}
