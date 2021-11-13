
import Foundation

enum DownloadError: Error {
    case packetFetchError(String)
    case wrongOrder(String)
}

protocol DownloadProcessProtocol {
    func downloadSucceeded(_ fileName: String)
    func downloadWithError(_ error: Error?, fileName: String)
}

class DownloadManager: NSObject {
    
    fileprivate var operations = [Int: DownloadOperation]()
    
    static var maxOperationCount = 10
    
    var lock = DispatchSemaphore(value: 1)
    
    private let queue: OperationQueue = {
        let _queue = OperationQueue()
        _queue.name = "download"
        _queue.maxConcurrentOperationCount = maxOperationCount
        return _queue
    }()
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var  processDelegate : DownloadProcessProtocol?
    
    @discardableResult
    func addDownloadOperation(_ urlPair: URLPair) -> DownloadOperation {
        lock.wait()
        defer{ lock.signal()}
        let operation = DownloadOperation(session: session, urlPair: urlPair)
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
        return operation
    }

    func cancelAll() {
        queue.cancelAllOperations()
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        lock.wait()
        defer{lock.signal()}
        operations[downloadTask.taskIdentifier]?.trackDownloadByOperation(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        if let downloadUrl = downloadTask.originalRequest!.url {
            DispatchQueue.main.async { [self] in
                processDelegate?.downloadSucceeded(downloadUrl.lastPathComponent)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        lock.wait()
        defer{lock.signal()}
        let key = task.taskIdentifier
        operations[key]?.trackDownloadByOperation(session, task: task, didCompleteWithError: error)
        operations.removeValue(forKey: key)
        
        if let downloadUrl = task.originalRequest!.url, error != nil {
            DispatchQueue.main.async { [self] in
                processDelegate?.downloadWithError(error, fileName: downloadUrl.lastPathComponent)
            }
        }
    }
}
