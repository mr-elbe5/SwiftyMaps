//
//  MapDownloadViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.09.21.
//

import Foundation
import UIKit
import MapKit
import SwiftyIOSViewExtensions

class MapDownloadViewController: ScrollViewController, DownloadProcessProtocol{
    
    var mapType: MapType? = nil
    var region: MKCoordinateRegion? = nil
    var mainView = UIView()
    
    var allTiles = 0
    var existingTiles = 0
    var tilesToLoad = 0
    var loadedTiles = 0
    var errors = 0
    
    var urlPairs = [URLPair]()
    
    override func loadView() {
        super.loadView()
        scrollView.addSubview(mainView)
        mainView.fillSuperview(insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        scrollChild = mainView
    }
    
    override open func setupHeaderView(){
        setupCloseHeader()
    }
    
    func prepareDownload(){
        allTiles = 0
        existingTiles = 0
        tilesToLoad = 0
        loadedTiles = 0
        errors = 0
        urlPairs.removeAll()
        if let mapType = mapType, let overlay = mapType.getTileOverlay(), let urlTemplate = overlay.urlTemplate, let region = region{
            let list = region.getTileList(minZoom: 6, maxZoom: 18)
            allTiles = list.count
            print("downloading \(allTiles) tiles")
            print("download size = \(list.count * Statics.tilesSize / 1024 / 1024) MB")
            for tile in list{
                guard let fileUrl = tile.fileUrl(type: mapType.name.rawValue) else {print("error creating file url"); return}
                if MapCache.instance.tileExists(url: fileUrl){
                    existingTiles += 1
                    continue
                }
                guard let url = tile.url(urlTemplate: urlTemplate) else {print("error creating download url"); return}
                urlPairs.append(URLPair(source: url, target: fileUrl))
            }
            print("\(existingTiles) tiles exist already")
            tilesToLoad = allTiles - existingTiles
            print("there are \(tilesToLoad) tiles to be downloaded")
        }
    }
    
    func startDownload(){
        allTiles = 0
        existingTiles = 0
        loadedTiles = 0
        errors = 0
        let downloadManager = DownloadManager()
        downloadManager.processDelegate = self
        let completion = BlockOperation {
            print("All of the download completed!")
        }
        urlPairs.forEach { urlPair in
            let downloadOperation = downloadManager.addDownloadOperation(urlPair)
            completion.addDependency(downloadOperation)
        }
        OperationQueue.main.addOperation(completion)
    }
    
    func downloadingProgress(_ percent: Float, fileName: String) {
    }
    
    func downloadSucceeded(_ fileName: String) {
        loadedTiles += 1
    }
    
    func downloadWithError(_ error: Error?, fileName: String) {
        errors += 1
    }
    
}


