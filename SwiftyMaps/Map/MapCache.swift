//
//  MapCache.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 19.09.21.
//

import Foundation
import MapKit

class MapCache{
    
    static var instance = MapCache()
    
    func getUrl(path: MKTileOverlayPath) -> URL?{
        URL(string: "tiles/\(path.z)/\(path.x)/\(path.y).png", relativeTo: Statics.privateURL)
    }
    
    func getDirUrl(path: MKTileOverlayPath) -> URL?{
        URL(string: "tiles/\(path.z)/\(path.x)", relativeTo: Statics.privateURL)
    }
    
    func shortPath(_ url: URL?) -> String{
        if let path : String = url?.path{
            if let idx = path.range(of: "tiles", options: .backwards)?.lowerBound{
                return String(path[idx..<path.endIndex])
            }
        }
        return "...no tiles path"
    }
    
    func tileExists(url: URL) -> Bool{
        FileManager.default.fileExists(atPath: url.path)
    }
    
    func getTile(path: MKTileOverlayPath) -> Data?{
        if let url = getUrl(path: path), tileExists(url: url), let fileData = FileManager.default.contents(atPath: url.path){
            //print("getting tile \(shortPath(url))")
            return fileData
        }
        return nil
    }
    
    func saveTile(path: MKTileOverlayPath, tile: Data?) -> Bool{
        if let dirUrl = getDirUrl(path: path), let url = getUrl(path: path), let data = tile{
            //print("save tile \(shortPath(url)) in \(shortPath(dirUrl))")
            var isDir:ObjCBool = true
            if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir) {
                do{
                    //print("creating path for \(shortPath(dirUrl))")
                    try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true)
                }
                catch{
                    print("could not create directory")
                    return false
                }
            }
            do{
                try data.write(to: url, options: .atomic)
                //print("file saved to \(shortPath(url))")
                return true
            } catch let err{
                print("Error saving tile: " + err.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func getTilePaths() -> Array<String>{
        var paths = Array<String>()
        if let url = URL(string: "tiles", relativeTo: Statics.privateURL){
            if let subpaths = FileManager.default.subpaths(atPath: url.path){
                for path in subpaths{
                    if !path.hasSuffix(".png"){
                        continue
                    }
                    paths.append(path)
                }
                paths.sort()
            }
        }
        return paths
    }
    
    func dumpTiles(){
        let paths = getTilePaths()
        for path in paths{
            print(path)
        }
    }
    
}
