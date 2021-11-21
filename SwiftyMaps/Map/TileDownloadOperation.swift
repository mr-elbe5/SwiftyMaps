import Foundation

protocol DownloadDelegate {
    func downloadSucceeded()
    func downloadWithError()
}

class TileDownloadOperation : AsyncOperation {
    
    var tile : MapTile
    
    var delegate : DownloadDelegate? = nil
    
    init(tile: MapTile) {
        self.tile = tile
        super.init()
    }
    
    override func startExecution(){
        //print("starting \(tile.id)")
        guard let sourceUrl = MapTileLoader.url(tile: tile, urlTemplate: MapController.defaultUrl) else {print("could not create map source url"); return}
        guard let targetUrl = MapTileFiles.fileUrl(tile: tile) else {print("could not create map target url"); return}
        MapTileLoader.loadTileImage(url: sourceUrl){ data in
            if let data = data, MapTileFiles.saveTile(fileUrl: targetUrl, data: data){
                DispatchQueue.main.async { [self] in
                    //print("got \(tile.id)")
                    delegate?.downloadSucceeded()
                }
            }
            else{
                DispatchQueue.main.async { [self] in
                    print("error on loading \(tile.id)")
                    delegate?.downloadWithError()
                }
            }
            self.state = .isFinished
        }
    }
    
}

