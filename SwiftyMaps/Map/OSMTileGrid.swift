//
//  OSMRegion.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 05.10.21.
//

import Foundation
import UIKit
import CoreLocation

class OSMTileGrid{
    
    
    private var grid = [[OSMTileData]]()
    
    var minX : Int = 0
    var maxX : Int = 0
    var minY : Int = 0
    var maxY : Int = 0
    var zoom : Int = 0
    
    var isEmpty : Bool{
        get{
            grid.isEmpty
        }
    }
    
    var width : Int{
        get{
            if maxX >= minX{
                return maxX - minX + 1
            }
            else{
                return maxX + 2^zoom - minX + 1
            }
        }
    }
    
    var height : Int{
        get{
            maxY - minY + 1
        }
    }
    
    var size : Int{
        get{
            width * height
        }
    }
    
    func setGrid(center: CLLocationCoordinate2D, rect: CGRect ){
        let w = rect.width/256 + 1
        let h = rect.height * w / rect.width
        
        let minLatitude = center.latitude
        
        let maxLatitude = center.latitude
        
        let minLongitude = center.longitude
        
        let maxLongitude = center.longitude
        
        
        
        setGrid(minLongitude: minLongitude, maxLongitude: maxLongitude, minLatitude: minLatitude, maxLatitude: maxLatitude, zoom: zoom)
    }
    
    func setGrid(minLongitude: Double, maxLongitude: Double, minLatitude: Double, maxLatitude: Double, zoom: Int){
        self.zoom = zoom
        let topLeft = OSM.tranformCoordinate(minLatitude, minLongitude, withZoom: zoom)
        minX = topLeft.x
        maxY = topLeft.y + 1
        let bottomRight = OSM.tranformCoordinate(maxLatitude, maxLongitude, withZoom: zoom)
        maxX = bottomRight.x + 1
        minY = bottomRight.y
        grid.removeAll()
        if maxX >= minX{
            // within -180° to 180°
            for x in minX...maxX{
                appendRow(x: x)
            }
        }
        else{
            // to 180°
            for x in minX..<(2^zoom){
                appendRow(x: x)
            }
            //from -180°
            for x in 0...maxX{
                appendRow(x: x)
            }
        }
    }
    
    private func appendRow(x: Int){
        var row = [OSMTileData]()
        for y in minY...maxY{
            row.append(OSMTileData(x: x, y: y, z: zoom))
        }
        grid.append(row)
    }
    
}
