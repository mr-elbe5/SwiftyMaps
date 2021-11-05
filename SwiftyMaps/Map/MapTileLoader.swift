/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

struct MapTileLoader{
    
    static func loadTileImage(tile: MapTile, result: @escaping (Data?) -> Void) {
        //print("loading tile image \(tile.zoom)/\(tile.x)/\(tile.y)")
        let urlTemplate = MapType.current.tileUrl
        //print("urlTemplate = \(urlTemplate)")
        let url = URL(string: urlTemplate.replacingOccurrences(of: "{z}", with: String(tile.zoom)).replacingOccurrences(of: "{x}", with: String(tile.x)).replacingOccurrences(of: "{y}", with: String(tile.y)))!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var statusCode = 0
            if (response != nil && response is HTTPURLResponse){
                let httpResponse = response! as! HTTPURLResponse
                statusCode = httpResponse.statusCode
            }
            if let error = error {
                print("error loading tile from \(url.path), error: \(error.localizedDescription)")
                result(nil)
            } else if statusCode == 200{
                //print("tile image \(tile.zoom)/\(tile.x)/\(tile.y) loaded")
                result(data)
            }
            else{
                print("error loading tile from \(url.path), statusCode=\(statusCode)")
                result(nil)
            }
        }
        task.resume()
    }
    
}
