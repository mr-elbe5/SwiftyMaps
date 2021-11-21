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
    var size : Int
    
    var tiles = Dictionary<Int, TileSet>()
    
    init(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D, maxZoom: Int){
        maxLatitude = topLeft.latitude
        minLatitude = bottomRight.latitude
        minLongitude = topLeft.longitude
        maxLongitude = bottomRight.longitude
        self.maxZoom = maxZoom
        size = 0
        updateTileSets()
        for zoom in tiles.keys{
            if let tileSet = tiles[zoom]{
                //print("zoom \(zoom): \(tileSet) with size \(tileSet.size)")
                size += tileSet.size
            }
        }
        //dump()
    }
    
    func updateTileSets(){
        tiles.removeAll()
        for zoom in 0...maxZoom{
            let bottomLeftTile = MapController.tileCoordinate(latitude: minLatitude, longitude: minLongitude, zoom: zoom)
            let topRightTile = MapController.tileCoordinate(latitude: maxLatitude, longitude: maxLongitude, zoom: zoom)
            let tileSet = TileSet(minX: bottomLeftTile.x, minY: bottomLeftTile.y, maxX: topRightTile.x, maxY: topRightTile.y)
            tiles[zoom] = tileSet
        }
    }
    
    func dump(){
        print("minLatitude = \(minLatitude)")
        print("maxLatitude = \(maxLatitude)")
        print("minLongitude = \(minLongitude)")
        print("maxLongitude = \(maxLongitude)")
        print("size = \(size)")
    }
    
}

class TileSet{
    
    var minX = 0
    var minY = 0
    var maxX = 0
    var maxY = 0
    
    init(minX: Int, minY: Int, maxX: Int, maxY: Int){
        self.minX = min(minX, maxX)
        self.maxX = max(maxX, minX)
        self.minY = min(minY, maxY)
        self.maxY = max(maxY, minY)
    }
    
    var size : Int{
        get{
            (maxX - minX + 1) * (maxY - minY + 1)
        }
    }
    
}
