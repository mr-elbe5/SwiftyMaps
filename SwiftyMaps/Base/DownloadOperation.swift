import Foundation

class DownloadOperation : AsyncOperation {
    
    var task: URLSessionTask!
    var targetUrl: URL!
    
    init(session: URLSession, urlPair: URLPair) {
        task = session.downloadTask(with: urlPair.source)
        targetUrl = urlPair.target
        super.init()
    }
    
    override func startExecution(){
        task.resume()
    }
    
    func trackDownloadByOperation(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            print("finish")
            let manager = FileManager.default
            if manager.fileExists(atPath:  targetUrl.path) {
                try manager.removeItem(at: targetUrl)
            }
            assertDirectory(for: targetUrl)
            try manager.moveItem(at: location, to: targetUrl)
        }
        catch {
            print("\(error)")
        }
        self.state = .isFinished
    }
    
    func trackDownloadByOperation(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("\(String(describing: error))")
        }
        self.state = .isFinished
    }
    
    func assertDirectory(for fileUrl: URL){
        let dirURL = fileUrl.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: dirURL.path){
            do{
                try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
            }
            catch{
                print("could not create directory for: \(targetUrl.path)")
            }
        }
    }
    
}
