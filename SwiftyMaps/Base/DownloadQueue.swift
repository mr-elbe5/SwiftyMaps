//
//  DownloadQueue.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 14.11.21.
//

import Foundation

protocol DownloadDelegate {
    func downloadSucceeded(_ fileName: String)
    func downloadWithError(_ error: Error?, fileName: String)
}

class DownloadQueue : OperationQueue{
    
    fileprivate var operationMap = SafeMap<Int, DownloadOperation>()
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var  delegate : DownloadDelegate?
    
    override init(){
        super.init()
        name = "downloadQueue"
    }
    
    init(maxConcurrent : Int){
        super.init()
        name = "downloadQueue"
        maxConcurrentOperationCount = maxConcurrent
    }
    
    @discardableResult
    func addDownloadOperation(_ urlPair: URLPair) -> DownloadOperation {
        let operation = DownloadOperation(session: session, urlPair: urlPair)
        operationMap.add(at: operation.task.taskIdentifier, operation)
        addOperation(operation)
        return operation
    }
    
}

extension DownloadQueue: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operationMap.get(at: downloadTask.taskIdentifier)?.trackDownloadByOperation(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        if let downloadUrl = downloadTask.originalRequest!.url {
            DispatchQueue.main.async { [self] in
                delegate?.downloadSucceeded(downloadUrl.lastPathComponent)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionTask, didCompleteWithError error: Error?) {
        let key = downloadTask.taskIdentifier
        operationMap.get(at: key)?.trackDownloadByOperation(session, task: downloadTask, didCompleteWithError: error)
        if let downloadUrl = downloadTask.originalRequest!.url, error != nil {
            DispatchQueue.main.async { [self] in
                delegate?.downloadWithError(error, fileName: downloadUrl.lastPathComponent)
            }
        }
    }
}



