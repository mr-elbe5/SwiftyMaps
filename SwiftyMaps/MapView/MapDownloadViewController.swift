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
    
    var downloadQueue : DownloadQueue?
    
    var maxZoom = MapType.current.maxZoom
    
    var allTiles = 0
    var existingTiles = 0
    var tilesToLoad = 0
    var loadedTiles = 0
    var errors = 0
    
    var urlPairs = [URLPair]()
    
    var scrollView = UIScrollView()
    
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
        header.setAnchors(top: mainView.topAnchor, leading: nil, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
            .centerX(mainView.centerXAnchor)
        
        let note = UILabel()
        note.numberOfLines = 0
        note.lineBreakMode = .byWordWrapping
        note.text = "mapDownloadNote".localize()
        mainView.addSubview(note)
        note.setAnchors(top: header.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        let allTilesLabel = UILabel()
        allTilesLabel.text = "allTilesForDownload".localize()
        mainView.addSubview(allTilesLabel)
        allTilesLabel.setAnchors(top: note.bottomAnchor, leading: mainView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        mainView.addSubview(allTilesValueLabel)
        allTilesValueLabel.setAnchors(top: note.bottomAnchor, leading: allTilesLabel.trailingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        
        let existingTilesLabel = UILabel()
        existingTilesLabel.text = "existingTiles".localize()
        mainView.addSubview(existingTilesLabel)
        existingTilesLabel.setAnchors(top: allTilesLabel.bottomAnchor, leading: mainView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        mainView.addSubview(existingTilesValueLabel)
        existingTilesValueLabel.setAnchors(top: allTilesLabel.bottomAnchor, leading: existingTilesLabel.trailingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        
        let tilesToLoadLabel = UILabel()
        tilesToLoadLabel.text = "tilesToLoad".localize()
        mainView.addSubview(tilesToLoadLabel)
        tilesToLoadLabel.setAnchors(top: existingTilesLabel.bottomAnchor, leading: mainView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        mainView.addSubview(tilesToLoadValueLabel)
        tilesToLoadValueLabel.setAnchors(top: existingTilesLabel.bottomAnchor, leading: tilesToLoadLabel.trailingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        
        let maxZoomLabel = UILabel()
        maxZoomLabel.text = "maxZoom".localize()
        mainView.addSubview(maxZoomLabel)
        maxZoomLabel.setAnchors(top: tilesToLoadLabel.bottomAnchor, leading: mainView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        maxZoomValueLabel.text = String(maxZoom)
        mainView.addSubview(maxZoomValueLabel)
        maxZoomValueLabel.setAnchors(top: tilesToLoadLabel.bottomAnchor, leading: maxZoomLabel.trailingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        
        maxZoomSlider.minimumValue = 0
        maxZoomSlider.maximumValue = Float(maxZoom)
        maxZoomSlider.value = Float(maxZoom)
        maxZoomSlider.isContinuous = true
        maxZoomSlider.addTarget(self, action: #selector(zoomChanged), for: .valueChanged)
        mainView.addSubview(maxZoomSlider)
        maxZoomSlider.setAnchors(top: maxZoomLabel.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        startButton.setTitle("start".localize(), for: .normal)
        startButton.setTitleColor(.systemBlue, for: .normal)
        startButton.setTitleColor(.systemGray, for: .disabled)
        startButton.addTarget(self, action: #selector(startDownload), for: .touchDown)
        mainView.addSubview(startButton)
        startButton.setAnchors(top: maxZoomSlider.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.centerXAnchor, bottom: nil, insets: Insets.defaultInsets)
        cancelButton.setTitle("cancel".localize(), for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .disabled)
        cancelButton.addTarget(self, action: #selector(cancelDownload), for: .touchDown)
        mainView.addSubview(cancelButton)
        cancelButton.setAnchors(top: maxZoomSlider.bottomAnchor, leading: mainView.centerXAnchor, trailing: mainView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        loadedTilesSlider.minimumValue = 0
        loadedTilesSlider.maximumValue = Float(tilesToLoad)
        loadedTilesSlider.value = 0
        mainView.addSubview(loadedTilesSlider)
        loadedTilesSlider.setAnchors(top: startButton.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        
        let errorsInfo = UILabel()
        errorsInfo.text = "unloadedTiles".localize()
        mainView.addSubview(errorsInfo)
        errorsInfo.setAnchors(top: loadedTilesSlider.bottomAnchor, leading: mainView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        errorsValueLabel.text = String(errors)
        mainView.addSubview(errorsValueLabel)
        errorsValueLabel.setAnchors(top: loadedTilesSlider.bottomAnchor, leading: errorsInfo.trailingAnchor, trailing: nil, bottom: nil, insets: Insets.defaultInsets)
        
        closeButton.setTitle("close".localize(), for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.setTitleColor(.systemGray, for: .disabled)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        mainView.addSubview(closeButton)
        closeButton.setAnchors(top: errorsInfo.bottomAnchor, leading: nil, trailing: nil, bottom: mainView.bottomAnchor, insets: Insets.defaultInsets)
            .centerX(mainView.centerXAnchor)
        
        prepareDownload()
        updateValueViews()
        
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
    
    func reset(){
        allTiles = 0
        existingTiles = 0
        tilesToLoad = 0
        loadedTiles = 0
        errors = 0
    }
    
    func updateValueViews(){
        allTilesValueLabel.text = String(allTiles)
        existingTilesValueLabel.text = String(existingTiles)
        tilesToLoadValueLabel.text = String(tilesToLoad)
        errorsValueLabel.text = String(errors)
        loadedTilesSlider.maximumValue = Float(allTiles)
        updateSliderValue()
        updateSliderColor()
    }
    
    func updateSliderValue(){
        loadedTilesSlider.value = Float(existingTiles + loadedTiles + errors)
    }
    
    func updateSliderColor(){
        loadedTilesSlider.thumbTintColor = (existingTiles + loadedTiles + errors == allTiles) ? (errors > 0 ? .systemRed : .systemGreen) : .systemGray
    }
    
    func prepareDownload(){
        urlPairs.removeAll()
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
                                guard let url = MapTileLoader.url(tile: tile, urlTemplate: MapType.current.tileUrl) else {print("could not create map url"); return}
                                urlPairs.append(URLPair(source: url, target: fileUrl))
                                tilesToLoad += 1
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
        }
    }
    
    @objc func startDownload(){
        if errors > 0{
            errors = 0
            updateValueViews()
        }
        startButton.isEnabled = false
        cancelButton.isEnabled = true
        closeButton.isEnabled = false
        downloadQueue = DownloadQueue(maxConcurrent: 2)
        downloadQueue!.delegate = self
        self.urlPairs.forEach { urlPair in
            downloadQueue!.addDownloadOperation(urlPair)
        }
    }
    
    @objc func cancelDownload(){
        downloadQueue?.reset()
        reset()
        prepareDownload()
        updateValueViews()
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
    
    func downloadSucceeded() {
        existingTiles += 1
        loadedTiles += 1
        tilesToLoad -= 1
        updateSliderValue()
        self.existingTilesValueLabel.text = String(self.existingTiles)
        self.tilesToLoadValueLabel.text = String(self.tilesToLoad)
        checkCompletion()
    }
    
    func downloadWithError() {
        errors += 1
        errorsValueLabel.text = String(self.errors)
        updateSliderValue()
        checkCompletion()
    }
    
    private func checkCompletion(){
        if existingTiles + loadedTiles + errors == allTiles{
            updateSliderColor()
            startButton.isEnabled = errors > 0
            cancelButton.isEnabled = false
            closeButton.isEnabled = true
            downloadQueue?.reset()
            downloadQueue = nil
        }
    }
    
}


