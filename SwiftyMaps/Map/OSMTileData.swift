//
//  OSMTileData.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 05.10.21.
//

import Foundation

struct OSMTileData{
    
    var x: Int
    var y: Int
    var z: Int
    
    func url(urlTemplate: String) -> URL?{
        URL(string: urlTemplate.replacingOccurrences(of: "{z}", with: String(z)).replacingOccurrences(of: "{x}", with: String(x)).replacingOccurrences(of: "{y}", with: String(y)))
    }
    
    func fileUrl(type: String) -> URL?{
        URL(string: "tiles/\(type)/\(z)/\(x)/\(y).png", relativeTo: Statics.privateURL)
    }
    
    func dirUrl(type: String) -> URL?{
        URL(string: "tiles/\(type)/\(z)/\(x)", relativeTo: Statics.privateURL)
    }
        
}
