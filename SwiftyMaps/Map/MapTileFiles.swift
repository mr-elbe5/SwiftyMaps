/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

struct MapTileFiles{
    
    static var tilesDirectory = "files"
    
    static var privateURL : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    static func fileUrl(tile: MapTile) -> URL?{
        URL(string: "\(tilesDirectory)/\(tile.zoom)/\(tile.x)/\(tile.y).png", relativeTo: MapTileFiles.privateURL)
    }
    
    static func shortPath(_ url: URL?) -> String{
        if let path : String = url?.path{
            if let idx = path.range(of: tilesDirectory, options: .backwards)?.lowerBound{
                return String(path[idx..<path.endIndex])
            }
        }
        return "...no tiles path"
    }
    
    static func tileExists(tile: MapTile) -> Bool{
        if let url = fileUrl(tile: tile){
            return tileExists(url: url)
        }
        return false
    }
    
    static func tileExists(url: URL) -> Bool{
        FileManager.default.fileExists(atPath: url.path)
    }
    
    static func getTile(zoom: Int, x: Int, y: Int) -> MapTile{
        let tile = MapTile(zoom: zoom, x: x, y: y)
        if let fileUrl = fileUrl(tile: tile), tileExists(url: fileUrl), let fileData = FileManager.default.contents(atPath: fileUrl.path){
            //print("getting image from file \(shortPath(fileUrl))")
            tile.image = UIImage(data: fileData)
        }
        return tile
    }
    
    static func saveTile(tile: MapTile, data: Data?) -> Bool{
        if let fileUrl = fileUrl(tile: tile){
            return saveTile(fileUrl: fileUrl, data: data)
        }
        return false
    }
    
    static func saveTile(fileUrl: URL, data: Data?) -> Bool{
        if let data = data{
            let dirUrl = fileUrl.deletingLastPathComponent()
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
                try data.write(to: fileUrl, options: .atomic)
                //print("file saved to \(shortPath(url))")
                return true
            } catch let err{
                print("Error saving tile: " + err.localizedDescription)
                return false
            }
        }
        return false
    }
    
    static func getTilePaths() -> Array<String>{
        var paths = Array<String>()
        if let url = URL(string: tilesDirectory, relativeTo: MapTileFiles.privateURL){
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
    
    @discardableResult
    static func clear() -> Bool{
        if let url = URL(string: tilesDirectory, relativeTo: MapTileFiles.privateURL){
            do{
                try FileManager.default.removeItem(at: url)
                print("tile directory deleted")
                return true
            }
            catch{
                print(error)
            }
        }
        return false
    }
    
    static func dumpTiles(){
        let paths = getTilePaths()
        for path in paths{
            print(path)
        }
    }
    
}
