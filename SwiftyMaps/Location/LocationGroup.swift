/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class LocationGroup : Hashable, Codable{
    
    static func == (lhs: LocationGroup, rhs: LocationGroup) -> Bool {
        lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case locations
    }
    
    var id : UUID
    var locations : LocationList
    
    private var lock = DispatchSemaphore(value: 1)
    
    init(){
        id = UUID()
        locations = LocationList()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        locations = try values.decodeIfPresent(LocationList.self, forKey: .locations) ?? LocationList()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(locations, forKey: .locations)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
