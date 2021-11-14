//
//  MapDownloadViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.09.21.
//

import Foundation
import UIKit

class MapDownloadViewController: UIViewController{
    
    var mapRegion: MapRegion? = nil
    var mainView = UIView()
    
    var downloadQueue = DownloadQueue()
    
    var maxZoom = MapType.current.maxZoom
    
    var allTiles = 0
    var existingTiles = 0
    var tilesToLoad = 0
    var loadedTiles = 0
    var errors = 0
    
    var urlPairs = [URLPair]()
    
    var scrollView = UIScrollView()
    
    var allTilesInfo = UILabel()
    var existingTilesInfo = UILabel()
    var tilesToLoadInfo = UILabel()
    var sizeToLoadInfo = UILabel()
    
    var maxZoomSlider = UISlider()
    var maxZoomValueLabel = UILabel()
    
    var startButton = UIButton()
    var cancelButton = UIButton()
    
    var loadedTilesSlider = UISlider()
    var errorsInfo = UILabel()
    
    var closeButton = UIButton()
    
    override func loadView() {
        super.loadView()
        let guide = view.safeAreaLayoutGuide
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(guide.topAnchor, inset: .zero)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
        scrollView.addSubview(mainView)
        mainView.setAnchors()
            .top(scrollView.topAnchor)
            .width(scrollView.widthAnchor)
        let header = UILabel()
        header.text = "mapDownload".localize()
        header.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.5, weight: .bold)
        mainView.addSubview(header)
        header.setAnchors()
            .centerX(mainView.centerXAnchor)
            .top(mainView.topAnchor, inset: Insets.defaultInset)
        let allTilesLabel = UILabel()
        allTilesLabel.text = "allTilesForDownload".localize()
        mainView.addSubview(allTilesLabel)
        allTilesLabel.setAnchors()
            .leading(mainView.leadingAnchor, inset: Insets.defaultInset)
            .top(header.bottomAnchor, inset: Insets.defaultInset)
        mainView.addSubview(allTilesInfo)
        allTilesInfo.setAnchors()
            .leading(allTilesLabel.trailingAnchor,inset: 2 * Insets.defaultInset)
            .top(header.bottomAnchor, inset: Insets.defaultInset)
        
        let existingTilesLabel = UILabel()
        existingTilesLabel.text = "existingTiles".localize()
        mainView.addSubview(existingTilesLabel)
        existingTilesLabel.setAnchors()
            .leading(mainView.leadingAnchor, inset: Insets.defaultInset)
            .top(allTilesLabel.bottomAnchor, inset: Insets.defaultInset)
        mainView.addSubview(existingTilesInfo)
        existingTilesInfo.setAnchors()
            .leading(existingTilesLabel.trailingAnchor,inset: 2 * Insets.defaultInset)
            .top(allTilesInfo.bottomAnchor, inset: Insets.defaultInset)
        
        let tilesToLoadLabel = UILabel()
        tilesToLoadLabel.text = "tilesToLoad".localize()
        mainView.addSubview(tilesToLoadLabel)
        tilesToLoadLabel.setAnchors()
            .leading(mainView.leadingAnchor, inset: Insets.defaultInset)
            .top(existingTilesLabel.bottomAnchor, inset: Insets.defaultInset)
        mainView.addSubview(tilesToLoadInfo)
        tilesToLoadInfo.setAnchors()
            .leading(tilesToLoadLabel.trailingAnchor,inset: 2 * Insets.defaultInset)
            .top(existingTilesLabel.bottomAnchor, inset: Insets.defaultInset)
        
        let sizeToLoadLabel = UILabel()
        sizeToLoadLabel.text = "sizeToLoad".localize()
        mainView.addSubview(sizeToLoadLabel)
        sizeToLoadLabel.setAnchors()
            .leading(mainView.leadingAnchor, inset: Insets.defaultInset)
            .top(tilesToLoadLabel.bottomAnchor, inset: Insets.defaultInset)
        mainView.addSubview(sizeToLoadInfo)
        sizeToLoadInfo.setAnchors()
            .leading(sizeToLoadLabel.trailingAnchor,inset: 2 * Insets.defaultInset)
            .top(tilesToLoadLabel.bottomAnchor, inset: Insets.defaultInset)
        
        let maxZoomLabel = UILabel()
        maxZoomLabel.text = "maxZoom".localize()
        mainView.addSubview(maxZoomLabel)
        maxZoomLabel.setAnchors()
            .leading(mainView.leadingAnchor, inset: Insets.defaultInset)
            .top(sizeToLoadInfo.bottomAnchor, inset: Insets.defaultInset)
        maxZoomValueLabel.text = String(maxZoom)
        mainView.addSubview(maxZoomValueLabel)
        maxZoomValueLabel.setAnchors()
            .leading(maxZoomLabel.trailingAnchor, inset: Insets.defaultInset)
            .top(sizeToLoadInfo.bottomAnchor, inset: Insets.defaultInset)
        maxZoomSlider.minimumValue = 0
        maxZoomSlider.maximumValue = Float(maxZoom)
        maxZoomSlider.value = Float(maxZoom)
        maxZoomSlider.isContinuous = true
        maxZoomSlider.addTarget(self, action: #selector(zoomChanged), for: .valueChanged)
        mainView.addSubview(maxZoomSlider)
        maxZoomSlider.setAnchors()
            .leading(mainView.leadingAnchor, inset: 2 * Insets.defaultInset)
            .top(maxZoomLabel.bottomAnchor, inset: Insets.defaultInset)
            .trailing(mainView.trailingAnchor, inset: -2 * Insets.defaultInset)
        
        startButton.setTitle("start".localize(), for: .normal)
        startButton.setTitleColor(.systemBlue, for: .normal)
        startButton.setTitleColor(.systemGray, for: .disabled)
        startButton.addTarget(self, action: #selector(startDownload), for: .touchDown)
        mainView.addSubview(startButton)
        startButton.setAnchors()
            .leading(mainView.leadingAnchor,inset: Insets.defaultInset)
            .trailing(mainView.centerXAnchor, inset: Insets.defaultInset)
            .top(maxZoomSlider.bottomAnchor, inset: Insets.defaultInset)
        cancelButton.setTitle("cancel".localize(), for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .disabled)
        cancelButton.addTarget(self, action: #selector(cancelDownload), for: .touchDown)
        mainView.addSubview(cancelButton)
        cancelButton.setAnchors()
            .leading(mainView.centerXAnchor,inset: Insets.defaultInset)
            .trailing(mainView.trailingAnchor,inset: Insets.defaultInset)
            .top(maxZoomSlider.bottomAnchor, inset: Insets.defaultInset)
        
        loadedTilesSlider.minimumValue = 0
        loadedTilesSlider.maximumValue = Float(tilesToLoad)
        loadedTilesSlider.value = 0
        mainView.addSubview(loadedTilesSlider)
        loadedTilesSlider.setAnchors()
            .leading(mainView.leadingAnchor, inset: 2 * Insets.defaultInset)
            .top(startButton.bottomAnchor, inset: Insets.defaultInset)
            .trailing(mainView.trailingAnchor, inset: -2 * Insets.defaultInset)
        
        errorsInfo.text = "unloadedTiles".localize() + " " + String(errors)
        mainView.addSubview(errorsInfo)
        errorsInfo.setAnchors()
            .leading(mainView.leadingAnchor, inset: Insets.defaultInset)
            .top(loadedTilesSlider.bottomAnchor, inset: Insets.defaultInset)
        
        closeButton.setTitle("close".localize(), for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.setTitleColor(.systemGray, for: .disabled)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        mainView.addSubview(closeButton)
        closeButton.setAnchors()
            .centerX(mainView.centerXAnchor)
            .top(errorsInfo.bottomAnchor, inset: Insets.defaultInset)
            .bottom(mainView.bottomAnchor, inset: Insets.defaultInset)
        
        downloadQueue.delegate = self
        
        prepareDownload()
        if tilesToLoad == 0{
            startButton.isEnabled = false
            cancelButton.isEnabled = false
            closeButton.isEnabled = true
        }
        else{
            startButton.isEnabled = true
            cancelButton.isEnabled = false
            closeButton.isEnabled = true
        }
    }
    
    func prepareDownload(){
        urlPairs.removeAll()
        if let region = mapRegion{
            allTiles = 0
            existingTiles = 0
            for zoom in region.tiles.keys{
                if zoom > maxZoom{
                    continue
                }
                if let tileSet = region.tiles[zoom]{
                    for x in tileSet.minX...tileSet.maxX{
                        for y in tileSet.minY...tileSet.maxY{
                            let tile = MapTile(zoom: zoom, x: x, y: y)
                            allTiles += 1
                            if let fileUrl = MapTileCache.fileUrl(tile: tile){
                                if MapTileCache.tileExists(url: fileUrl){
                                    existingTiles += 1
                                    continue
                                }
                                if let url = MapTileLoader.url(tile: tile, urlTemplate: MapType.current.tileUrl){
                                    urlPairs.append(URLPair(source: url, target: fileUrl))
                                }
                            }
                            
                        }
                    }
                }
            }
            allTilesInfo.text = String(allTiles)
            existingTilesInfo.text = String(existingTiles)
            tilesToLoad = allTiles - existingTiles
            tilesToLoadInfo.text = String(tilesToLoad)
            sizeToLoadInfo.text = "\(tilesToLoad * MapStatics.averageTileLoadSize) kB"
            loadedTilesSlider.maximumValue = Float(tilesToLoad)
        }
    }
    
    @objc func zoomChanged(){
        let zoom = Int(round(maxZoomSlider.value))
        if zoom != maxZoom{
            maxZoom = zoom
            maxZoomValueLabel.text = String(maxZoom)
            prepareDownload()
        }
    }
    
    @objc func startDownload(){
        allTiles = 0
        existingTiles = 0
        loadedTiles = 0
        errors = 0
        startButton.isEnabled = false
        cancelButton.isEnabled = true
        closeButton.isEnabled = false
        let completion = BlockOperation {
            DispatchQueue.main.async{
                self.loadedTilesSlider.thumbTintColor = .systemGreen
                self.startButton.isEnabled = self.errors > 0
                self.cancelButton.isEnabled = false
                self.closeButton.isEnabled = true
            }
        }
        self.urlPairs.forEach { urlPair in
            let downloadOperation = self.downloadQueue.addDownloadOperation(urlPair)
            completion.addDependency(downloadOperation)
        }
        OperationQueue.main.addOperation(completion)
    }
    
    @objc func cancelDownload(){
        downloadQueue.cancelAllOperations()
        startButton.isEnabled = true
        cancelButton.isEnabled = false
        closeButton.isEnabled = true
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
}

extension MapDownloadViewController: DownloadDelegate{
    
    func downloadSucceeded(_ fileName: String) {
        DispatchQueue.main.async{
            self.loadedTiles += 1
            self.loadedTilesSlider.value = Float(self.loadedTiles)
        }
    }
    
    func downloadWithError(_ error: Error?, fileName: String) {
        DispatchQueue.main.async{
            self.errors += 1
            self.errorsInfo.text = "unloadedTiles".localize() + ": " + String(self.errors)
        }
    }
    
}


