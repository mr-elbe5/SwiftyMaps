//
//  MapOverlay.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 17.09.21.
//

import Foundation
import MapKit

protocol MapTileOverlayDelegate{
    func zoomChanged(from: Int, to: Int)
}

class MapTileOverlay : MKTileOverlay{
    
    var zoom : Int = 0
    var mapType : String = ""
    
    var delegate : MapTileOverlayDelegate? = nil
    
    var renderer : MKTileOverlayRenderer? = nil
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        if zoom != path.z{
            let oldZoom = zoom
            let newZoom = path.z
            DispatchQueue.main.async {
                self.delegate?.zoomChanged(from: oldZoom, to: newZoom)
            }
            zoom = path.z
        }
        let tileData = TileData(x: path.x, y: path.y, z: path.z)
        if let tile = MapCache.instance.getTile(type: mapType, tile: tileData){
            result(tile, nil)
            return
        }
        let url = url(forTilePath: path)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var statusCode = 0
            if (response != nil && response is HTTPURLResponse){
                let httpResponse = response! as! HTTPURLResponse
                statusCode = httpResponse.statusCode
            }
            if let error = error {
                print("error loading map tile from \(url.path), error: \(error.localizedDescription)")
                result(nil, error)
            } else if (statusCode == 200 ){
                if !MapCache.instance.saveTile(type: self.mapType, tile: tileData, data: data){
                    print("could not save tile")
                }
                result(data, nil)
            }
            else{
                print("error loading map tile from \(url.path), statusCode=\(statusCode)")
                result(nil, MapError.load)
            }
        }
        task.resume()
    }
}

