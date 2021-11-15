import Foundation

protocol DownloadDelegate {
    func downloadSucceeded()
    func downloadWithError()
}

class DownloadOperation : AsyncOperation {
    
    var id: UUID
    var sourceUrl: URL
    var targetUrl: URL
    
    var delegate : DownloadDelegate? = nil
    
    init(urlPair: URLPair) {
        id = UUID()
        sourceUrl = urlPair.source
        targetUrl = urlPair.target
        super.init()
    }
    
    override func startExecution(){
        MapTileLoader.loadTileImage(url: sourceUrl){ data in
            if let data = data, MapTileCache.saveTile(fileUrl: self.targetUrl, data: data){
                DispatchQueue.main.async { [self] in
                    delegate?.downloadSucceeded()
                }
            }
            else{
                DispatchQueue.main.async { [self] in
                    delegate?.downloadWithError()
                }
            }
        }
        self.state = .isFinished
    }
    
}

