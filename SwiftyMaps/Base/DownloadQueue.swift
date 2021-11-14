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
        addOperation(operation)
        return operation
    }
    
}

extension DownloadQueue: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let operation = operations[downloadTask.taskIdentifier] as? DownloadOperation{
            operation.trackDownloadByOperation(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        }
        if let downloadUrl = downloadTask.originalRequest!.url {
            DispatchQueue.main.async { [self] in
                print("ok")
                delegate?.downloadSucceeded(downloadUrl.lastPathComponent)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionTask, didCompleteWithError error: Error?) {
        if let operation = operations[downloadTask.taskIdentifier] as? DownloadOperation{
            operation.trackDownloadByOperation(session, task: downloadTask, didCompleteWithError: error)
        }
        if let downloadUrl = downloadTask.originalRequest!.url, error != nil {
            DispatchQueue.main.async { [self] in
                print("err")
                delegate?.downloadWithError(error, fileName: downloadUrl.lastPathComponent)
            }
        }
    }
}



