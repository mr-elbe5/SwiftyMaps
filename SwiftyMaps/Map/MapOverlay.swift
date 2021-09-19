//
//  MapOverlay.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 17.09.21.
//

import Foundation
import MapKit

class MapTileOverlay : MKTileOverlay{
    
    var zoom : Int = 0
    
    var renderer : MKTileOverlayRenderer? = nil
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        if zoom != path.z{
            zoom = path.z
        }
        if let tile = MapCache.instance.getTile(path: path){
            result(tile, nil)
            return
        }
        let url = url(forTilePath: path)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var statusCode = 0
            if (response != nil && response is HTTPURLResponse){
                let httpResponse = response! as! HTTPURLResponse
                statusCode = httpResponse.statusCode
            }
            if let error = error {
                print("error loading map tile from \(url.path), error:\(error.localizedDescription)")
                result(nil, error)
            } else if (statusCode == 200 ){
                if !MapCache.instance.saveTile(path: path, tile: data){
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

