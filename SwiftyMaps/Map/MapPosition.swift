/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */


import Foundation
import UIKit
import CoreLocation

class MapPosition: Codable{
    
    static var storeKey = "position"
    
    static func loadPosition() -> MapPosition?{
        if let pos : MapPosition = DataController.shared.load(forKey: MapPosition.storeKey){
            return pos
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case scale
        case latitude
        case longitude
    }

    var scale : Double
    var coordinate : CLLocationCoordinate2D
    
    init(scale: Double, coordinate: CLLocationCoordinate2D){
        self.scale = scale
        self.coordinate = coordinate
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scale = try values.decode(Double.self, forKey: .scale)
        let lat = try values.decode(Double.self, forKey: .latitude)
        let lon = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scale, forKey: .scale)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    func save(){
        Log.log("saving position:")
        log()
        DataController.shared.save(forKey: MapPosition.storeKey, value: self)
    }
    
    func log(){
        Log.log("scale = \(scale)" )
        Log.log("coordinate = \(coordinate)" )
    }
    
}
