//
//  TourData.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation
import UIKit

class TourData : Hashable, Codable{
    
    static func == (lhs: TourData, rhs: TourData) -> Bool {
        lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case trackpoints
    }
    
    var id : UUID
    var description : String
    var trackpoints : Array<Location>
    
    init(){
        id = UUID()
        description = ""
        trackpoints = Array<Location>()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        trackpoints = try values.decodeIfPresent(Array<Location>.self, forKey: .trackpoints) ?? Array<Location>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(description, forKey: .description)
        try container.encode(trackpoints, forKey: .trackpoints)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

