//
//  MapDownloadViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.09.21.
//

import Foundation
import UIKit

class MapPreloadViewController: PopupViewController{
    
    var mapRegion: MapRegion? = nil
    
    var downloadQueue : OperationQueue?
    
    var maxZoom = MapType.current.maxZoom
    
    var allTiles = 0
    var existingTiles = 0
    var errors = 0
    
    var tiles = [MapTile]()
    
    var allTilesValueLabel = UILabel()
    var existingTilesValueLabel = UILabel()
    var tilesToLoadValueLabel = UILabel()
    
    var maxZoomSlider = UISlider()
    var maxZoomValueLabel = UILabel()
    
    var startButton = UIButton()
    var cancelButton = UIButton()
    
    var loadedTilesSlider = UISlider()
    var errorsValueLabel = UILabel()
    
    var closeButton = UIButton()
    
    override func loadView() {
        super.loadView()
        let header = UILabel()
        header.text = "mapPreload".localize()
        header.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.5, weight: .bold)
        contentView.addSubview(header)
        header.setAnchors(top: contentView.topAnchor, insets: Insets.defaultInsets)
            .centerX(contentView.centerXAnchor)
        
        let note1 = UILabel()
        note1.numberOfLines = 0
        note1.lineBreakMode = .byWordWrapping
        note1.text = "mapPreloadNote1".localize()
        contentView.addSubview(note1)
        note1.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        let note2 = UILabel()
        note2.numberOfLines = 0
        note2.lineBreakMode = .byWordWrapping
        note2.text = "mapPreloadNote2".localize()
        contentView.addSubview(note2)
        note2.setAnchors(top: note1.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        
        let allTilesLabel = UILabel()
        allTilesLabel.text = "allTilesForDownload".localize()
        contentView.addSubview(allTilesLabel)
        allTilesLabel.setAnchors(top: note2.bottomAnchor, leading: contentView.leadingAnchor, insets: Insets.defaultInsets)
        contentView.addSubview(allTilesValueLabel)
        allTilesValueLabel.setAnchors(top: note2.bottomAnchor, leading: allTilesLabel.trailingAnchor, insets: Insets.defaultInsets)
        
        let existingTilesLabel = UILabel()
        existingTilesLabel.text = "existingTiles".localize()
        contentView.addSubview(existingTilesLabel)
        existingTilesLabel.setAnchors(top: allTilesLabel.bottomAnchor, leading: contentView.leadingAnchor, insets: Insets.defaultInsets)
        contentView.addSubview(existingTilesValueLabel)
        existingTilesValueLabel.setAnchors(top: allTilesLabel.bottomAnchor, leading: existingTilesLabel.trailingAnchor, insets: Insets.defaultInsets)
        
        let tilesToLoadLabel = UILabel()
        tilesToLoadLabel.text = "tilesToLoad".localize()
        contentView.addSubview(tilesToLoadLabel)
        tilesToLoadLabel.setAnchors(top: existingTilesLabel.bottomAnchor, leading: contentView.leadingAnchor, insets: Insets.defaultInsets)
        contentView.addSubview(tilesToLoadValueLabel)
        tilesToLoadValueLabel.setAnchors(top: existingTilesLabel.bottomAnchor, leading: tilesToLoadLabel.trailingAnchor, insets: Insets.defaultInsets)
        
        let maxZoomLabel = UILabel()
        maxZoomLabel.text = "maxZoom".localize()
        contentView.addSubview(maxZoomLabel)
        maxZoomLabel.setAnchors(top: tilesToLoadLabel.bottomAnchor, leading: contentView.leadingAnchor, insets: Insets.defaultInsets)
        maxZoomValueLabel.text = String(maxZoom)
        contentView.addSubview(maxZoomValueLabel)
        maxZoomValueLabel.setAnchors(top: tilesToLoadLabel.bottomAnchor, leading: maxZoomLabel.trailingAnchor, insets: Insets.defaultInsets)
        
        maxZoomSlider.minimumValue = 0
        maxZoomSlider.maximumValue = Float(maxZoom)
        maxZoomSlider.value = Float(maxZoom)
        maxZoomSlider.isContinuous = true
        maxZoomSlider.addTarget(self, action: #selector(zoomChanged), for: .valueChanged)
        contentView.addSubview(maxZoomSlider)
        maxZoomSlider.setAnchors(top: maxZoomLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        
        startButton.setTitle("start".localize(), for: .normal)
        startButton.setTitleColor(.systemBlue, for: .normal)
        startButton.setTitleColor(.systemGray, for: .disabled)
        startButton.addTarget(self, action: #selector(startDownload), for: .touchDown)
        contentView.addSubview(startButton)
        startButton.setAnchors(top: maxZoomSlider.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.centerXAnchor, insets: Insets.defaultInsets)
        cancelButton.setTitle("cancel".localize(), for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .disabled)
        cancelButton.addTarget(self, action: #selector(cancelDownload), for: .touchDown)
        contentView.addSubview(cancelButton)
        cancelButton.setAnchors(top: maxZoomSlider.bottomAnchor, leading: contentView.centerXAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        
        loadedTilesSlider.minimumValue = 0
        loadedTilesSlider.maximumValue = Float(allTiles)
        loadedTilesSlider.value = 0
        contentView.addSubview(loadedTilesSlider)
        loadedTilesSlider.setAnchors(top: startButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.doubleInsets)
        
        let errorsInfo = UILabel()
        errorsInfo.text = "unloadedTiles".localize()
        contentView.addSubview(errorsInfo)
        errorsInfo.setAnchors(top: loadedTilesSlider.bottomAnchor, leading: contentView.leadingAnchor, insets: Insets.defaultInsets)
        errorsValueLabel.text = String(errors)
        contentView.addSubview(errorsValueLabel)
        errorsValueLabel.setAnchors(top: loadedTilesSlider.bottomAnchor, leading: errorsInfo.trailingAnchor, insets: Insets.defaultInsets)
        
        closeButton.setTitle("close".localize(), for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.setTitleColor(.systemGray, for: .disabled)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        contentView.addSubview(closeButton)
        closeButton.setAnchors(top: errorsInfo.bottomAnchor, bottom: contentView.bottomAnchor, insets: Insets.defaultInsets)
            .centerX(contentView.centerXAnchor)
        
        prepareDownload()
        updateValueViews()
        
        if existingTiles == allTiles{
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
    
    func reset(){
        allTiles = 0
        existingTiles = 0
        errors = 0
    }
    
    func updateValueViews(){
        allTilesValueLabel.text = String(allTiles)
        existingTilesValueLabel.text = String(existingTiles)
        tilesToLoadValueLabel.text = String(allTiles - existingTiles)
        errorsValueLabel.text = String(errors)
        loadedTilesSlider.maximumValue = Float(allTiles)
        updateSliderValue()
        updateSliderColor()
    }
    
    func updateSliderValue(){
        loadedTilesSlider.value = Float(existingTiles + errors)
    }
    
    func updateSliderColor(){
        loadedTilesSlider.thumbTintColor = (existingTiles + errors == allTiles) ? (errors > 0 ? .systemRed : .systemGreen) : .systemGray
    }
    
    func prepareDownload(){
        tiles.removeAll()
        if let region = mapRegion{
            reset()
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
                                tiles.append(tile)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func zoomChanged(){
        let zoom = Int(round(maxZoomSlider.value))
        if zoom != maxZoom{
            maxZoom = zoom
            maxZoomValueLabel.text = String(maxZoom)
            prepareDownload()
            updateValueViews()
        }
    }
    
    @objc func startDownload(){
        if tiles.isEmpty{
            return
        }
        if errors > 0{
            errors = 0
            updateValueViews()
        }
        startButton.isEnabled = false
        cancelButton.isEnabled = true
        closeButton.isEnabled = false
        downloadQueue = OperationQueue()
        downloadQueue!.name = "downloadQueue"
        downloadQueue!.maxConcurrentOperationCount = 2
        tiles.forEach { tile in
            let operation = TileDownloadOperation(tile: tile)
            operation.delegate = self
            downloadQueue!.addOperation(operation)
        }
    }
    
    @objc func cancelDownload(){
        downloadQueue?.cancelAllOperations()
        reset()
        prepareDownload()
        updateValueViews()
        startButton.isEnabled = true
        cancelButton.isEnabled = false
        closeButton.isEnabled = true
    }
    
}

extension MapPreloadViewController: DownloadDelegate{
    
    func downloadSucceeded() {
        existingTiles += 1
        updateSliderValue()
        self.existingTilesValueLabel.text = String(self.existingTiles)
        self.tilesToLoadValueLabel.text = String(self.allTiles - self.existingTiles)
        checkCompletion()
    }
    
    func downloadWithError() {
        errors += 1
        errorsValueLabel.text = String(self.errors)
        updateSliderValue()
        checkCompletion()
    }
    
    private func checkCompletion(){
        if existingTiles + errors == allTiles{
            updateSliderColor()
            startButton.isEnabled = errors > 0
            cancelButton.isEnabled = false
            closeButton.isEnabled = true
            downloadQueue?.cancelAllOperations()
            downloadQueue = nil
        }
    }
    
}


