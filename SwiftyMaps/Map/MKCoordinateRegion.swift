//
//  MKCoordinateRegion.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 21.09.21.
//

import Foundation
import MapKit

extension MKCoordinateRegion{
    
    var maxLatitude : Double{
        center.latitude + span.latitudeDelta/2
    }
    
    var minLatitude : Double{
        center.latitude - span.latitudeDelta/2
    }
    
    var minLongitude : Double{
        center.longitude - span.longitudeDelta/2
    }
    
    var maxLongitude : Double{
        center.longitude + span.longitudeDelta/2
    }
    
    func minTileX(zoom: Int) -> Int{
        return Int(floor((minLongitude + 180) / 360.0 * pow(2.0, Double(zoom))))
    }
    
    func maxTileX(zoom: Int) -> Int{
        return Int(floor((maxLongitude + 180) / 360.0 * pow(2.0, Double(zoom)))) + 1
    }
    
    func minTileY(zoom: Int) -> Int{
        return Int(floor((1 - log( tan( maxLatitude * Double.pi / 180.0 ) + 1 / cos( maxLatitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
    }
    
    func maxTileY(zoom: Int) -> Int{
        return Int(floor((1 - log( tan( minLatitude * Double.pi / 180.0 ) + 1 / cos( minLatitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom)))) + 1
    }
    
    func getTileList(minZoom: Int, maxZoom: Int) -> Array<TileData> {
        var list = Array<TileData>()
        //print("minLongitude = \(minLongitude)")
        //print("maxLongitude = \(maxLongitude)")
        //print("minLatitude = \(minLatitude)")
        //print("maxLatitude = \(maxLatitude)")
        for z in minZoom...maxZoom{
            //print("minTileX = \(minTileX(zoom: z))")
            //print("maxTileX = \(maxTileX(zoom: z))")
            //print("minTileY = \(minTileY(zoom: z))")
            //print("maxTileY = \(maxTileY(zoom: z))")
            for x in minTileX(zoom: z)...maxTileX(zoom: z){
                for y in minTileY(zoom: z)...maxTileY(zoom: z){
                    list.append(TileData(x: x, y: y, z: z))
                }
            }
        }
        return list
    }

}
