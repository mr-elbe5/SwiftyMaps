//
//  DownloadQueue.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 14.11.21.
//

import Foundation

class DownloadQueue : OperationQueue{
    
    fileprivate var operationMap = SafeMap<UUID, DownloadOperation>()
    
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
    
    func addDownloadOperation(_ urlPair: URLPair) {
        let operation = DownloadOperation(urlPair: urlPair)
        operation.delegate = delegate
        operationMap.add(at: operation.id, operation)
        addOperation(operation)
    }
    
    func reset(){
        operationMap.removeAll()
        cancelAllOperations()
    }
    
}




