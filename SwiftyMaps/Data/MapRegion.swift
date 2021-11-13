//
//  MapRegion.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 13.11.21.
//

import Foundation
import UIKit
import CoreLocation

class MapRegion{
    
    
    var minLatitude : CLLocationDegrees
    var maxLatitude : CLLocationDegrees
    var minLongitude : CLLocationDegrees
    var maxLongitude : CLLocationDegrees
    var maxZoom : Int
    
    var tiles = Dictionary<Int, TileSet>()
    
    init(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D, maxZoom: Int){
        maxLatitude = topLeft.latitude
        minLatitude = bottomRight.latitude
        minLongitude = topLeft.longitude
        maxLongitude = bottomRight.longitude
        self.maxZoom = maxZoom
        updateTileSets()
        dump()
    }
    
    func updateTileSets(){
        tiles.removeAll()
        for zoom in 0...maxZoom{
            let bottomLeftTile = MapCalculator.tileCoordinate(latitude: minLatitude, longitude: minLongitude, zoom: zoom)
            let topRightTile = MapCalculator.tileCoordinate(latitude: maxLatitude, longitude: maxLongitude, zoom: zoom)
            let tileSet = TileSet(minX: bottomLeftTile.x, minY: bottomLeftTile.y, maxX: topRightTile.x, maxY: topRightTile.y)
            tiles[zoom] = tileSet
        }
    }
    
    func dump(){
        print("minLatitude = \(minLatitude)")
        print("maxLatitude = \(maxLatitude)")
        print("minLongitude = \(minLongitude)")
        print("maxLongitude = \(maxLongitude)")
        var size = 0
        for zoom in tiles.keys{
            if let tileSet = tiles[zoom]{
                print("zoom \(zoom): \(tileSet) with size \(tileSet.size)")
                size += tileSet.size
            }
        }
        print("full size = \(size)")
    }
    
}

struct TileSet{
    
    var minX = 0
    var minY = 0
    var maxX = 0
    var maxY = 0
    
    var size : Int{
        get{
            (abs(maxX - minX) + 1) * (abs(maxY - minY) + 1)
        }
    }
    
}
