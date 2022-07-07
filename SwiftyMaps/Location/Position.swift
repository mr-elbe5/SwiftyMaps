
import Foundation
import CoreLocation

class Position  : Hashable, Codable{
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.coordinate == rhs.coordinate
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case timestamp
    }
    
    var coordinate : CLLocationCoordinate2D
    var altitude : CLLocationDistance = 0
    var timestamp : Date
    
    var horizontalAccuracy : CLLocationDistance = 0
    var verticalAccuracy : CLLocationDistance = 0
    
    var coordinateString : String{
        let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
        let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
        return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
    }
    
    init(position: Position){
        self.coordinate = position.coordinate
        self.altitude = position.altitude
        self.timestamp = position.timestamp
        self.horizontalAccuracy = position.horizontalAccuracy
        self.verticalAccuracy = position.verticalAccuracy
    }
    
    init(location: CLLocation){
        coordinate = location.coordinate
        altitude = location.altitude
        timestamp = location.timestamp
        horizontalAccuracy = location.horizontalAccuracy
        verticalAccuracy = location.verticalAccuracy
    }
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        altitude = 0
        timestamp = Date()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        altitude = try values.decodeIfPresent(Double.self, forKey: .altitude) ?? 0
        timestamp = try values.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
}
