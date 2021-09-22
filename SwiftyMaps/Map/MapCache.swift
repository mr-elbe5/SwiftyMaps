//
//  MapCache.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 19.09.21.
//

import Foundation

class MapCache{
    
    static var instance = MapCache()
    
    func shortPath(_ url: URL?) -> String{
        if let path : String = url?.path{
            if let idx = path.range(of: "tiles", options: .backwards)?.lowerBound{
                return String(path[idx..<path.endIndex])
            }
        }
        return "...no tiles path"
    }
    
    func tileExists(type: String, tile: TileData) -> Bool{
        if let url = tile.fileUrl(type: type){
            return tileExists(url: url)
        }
        return false
    }
    
    func tileExists(url: URL) -> Bool{
        FileManager.default.fileExists(atPath: url.path)
    }
    
    func getTile(type: String, tile: TileData) -> Data?{
        if let fileUrl = tile.fileUrl(type: type), tileExists(url: fileUrl), let fileData = FileManager.default.contents(atPath: fileUrl.path){
            //print("getting tile \(shortPath(url))")
            return fileData
        }
        return nil
    }
    
    func saveTile(type: String, tile: TileData, data: Data?) -> Bool{
        if let fileUrl = tile.fileUrl(type: type){
            return saveTile(fileUrl: fileUrl, data: data)
        }
        return false
    }
    
    func saveTile(fileUrl: URL, data: Data?) -> Bool{
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
    
    func removeTiles(type: String) -> Bool{
        if let url = URL(string: "tiles/\(type)", relativeTo: Statics.privateURL){
            do{
                try FileManager.default.removeItem(at: url)
                print("tile directory for type \(type) deleted")
                return true
            }
            catch{
                print(error)
            }
        }
        return false
    }
    
    func dumpTiles(){
        let paths = getTilePaths()
        for path in paths{
            print(path)
        }
    }
    
    /*func preloadTiles(list: Array<TileData>, type: String, urlTemplate: String){
        for tile in list{
            print("tile z=\(tile.z),x=\(tile.x),y=\(tile.y)")
            if tileExists(type: type, tile: tile){
                print("tile exists")
                continue
            }
            if let url = tile.url(urlTemplate: urlTemplate){
                let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    var statusCode = 0
                    if (response != nil && response is HTTPURLResponse){
                        let httpResponse = response! as! HTTPURLResponse
                        statusCode = httpResponse.statusCode
                    }
                    if let error = error {
                        print("error loading map tile from \(url.path), error:\(error.localizedDescription)")
                    } else if (statusCode == 200 ){
                        print("received tile")
                        if !MapCache.instance.saveTile(type: type, tile: tile, data: data){
                            print("could not save tile")
                        }
                    }
                    else{
                        print("error loading map tile from \(url.path), statusCode=\(statusCode)")
                    }
                }
                task.resume()
            }
        }
    }*/
    
    func preloadTiles(list: Array<TileData>, type: String, urlTemplate: String){
        let downloadManager = DownloadManager()
        let completion = BlockOperation {
            /// Do something here when all of the download is done
            print("All of the download completed!")
        }
        var urlPairs = [URLPair]()
        var existingTiles = 0
        for tile in list{
            guard let fileUrl = tile.fileUrl(type: type) else {print("error creating file url"); return}
            if tileExists(url: fileUrl){
                existingTiles += 1
                continue
            }
            guard let url = tile.url(urlTemplate: urlTemplate) else {print("error creating download url"); return}
            urlPairs.append(URLPair(source: url, target: fileUrl))
        }
        print("\(existingTiles) tiles exist already")
        print("there are \(urlPairs.count) tiles to be downloaded")
        urlPairs.forEach { urlPair in
            let downloadOperation = downloadManager.addDownloadOperation(urlPair)
                completion.addDependency(downloadOperation)
        }
        OperationQueue.main.addOperation(completion)
    }
}
