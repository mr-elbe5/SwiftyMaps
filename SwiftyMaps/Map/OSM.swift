//
//  OSM.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 05.10.21.
//

import Foundation

struct OSM{
    
    static var equatorInM : Double = 40075.016686 * 1000
    
    static func metersPerPixel(latitude: Double, zoom: Int) -> Double{
        156543.03 * cos(latitude) / Double(2^zoom)
    }
    
    static func tranformCoordinate(_ latitude: Double, _ longitude: Double, withZoom zoom: Int) -> (x: Int, y: Int) {
        let tileX = Int(floor((longitude + 180) / 360.0 * pow(2.0, Double(zoom))))
        let tileY = Int(floor((1 - log( tan( latitude * Double.pi / 180.0 ) + 1 / cos( latitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
        return (tileX, tileY)
    }
    
    static func tileToLatLon(tileX : Int, tileY : Int, mapZoom: Int) -> (lat_deg : Double, lon_deg : Double) {
        let n : Double = pow(2.0, Double(mapZoom))
        let lon = (Double(tileX) / n) * 360.0 - 180.0
        let lat = atan( sinh (.pi - (Double(tileY) / n) * 2 * Double.pi)) * (180.0 / .pi)
        
        return (lat, lon)
    }
    
    struct Tiles{
        
        var minX : Int = 0
        var maxX : Int = 0
        var minY : Int = 0
        var maxY : Int = 0
        var zoom : Int = 0
        
        var numTiles : Int{
            get{
                if maxX >= minX{
                    return (maxX - minX + 1) * (maxY - minY + 1)
                }
                else{
                    // add max tiles
                    return (maxX + 2^zoom - minX + 1) * (maxY - minY + 1)
                }
            }
        }
        
        init(minLongitude: Double, maxLongitude: Double, minLatitude: Double, maxLatitude: Double, zoom: Int){
            self.zoom = zoom
            let topLeft = tranformCoordinate(minLatitude, minLongitude, withZoom: zoom)
            minX = topLeft.x
            maxY = topLeft.y + 1
            let bottomRight = tranformCoordinate(maxLatitude, maxLongitude, withZoom: zoom)
            maxX = bottomRight.x + 1
            minY = bottomRight.y
        }
        
        func dump(){
            print("zoom: \(zoom): minX=\(minX), maxX=\(maxX), minY=\(minY), maxY=\(maxY). numTiles:\(numTiles)")
        }
        
    }

    
}
