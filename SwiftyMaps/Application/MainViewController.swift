//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit
import MapKit
import SwiftyIOSViewExtensions

class MainViewController: MapViewController {
    
    var menuView = UIView()
    var statusView = UIView()
    
    var isTracking : Bool = false

    override func loadView() {
        super.loadView()
        LocationService.shared.checkRunning()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(menuView)
        menuView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(guide.topAnchor, inset: .zero)
                .trailing(guide.trailingAnchor, inset: .zero)
        menuView.backgroundColor = .black
        fillMenu()
        mapView.mapType = .standard
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.isPitchEnabled = false
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(menuView.bottomAnchor, inset: 1)
                .trailing(guide.trailingAnchor, inset: .zero)
        view.addSubview(statusView)
        fillStatus()
        statusView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(mapView.bottomAnchor, inset: .zero)
                .trailing(guide.trailingAnchor, inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
        menuView.backgroundColor = .black
        applySettings()
    }
    
    func applySettings(){
        mapView.showsUserLocation = Settings.instance.showUserLocation
        setMapType(Settings.instance.mapTypeName.getMapType())
    }
    
    func updateSettings(){
        Settings.instance.showUserLocation = mapView.showsUserLocation
    }

    // menu

    var mapButton : MenuButton!
    var markerButton : MenuButton!
    var tourButton : MenuButton!
    
    var searchButton : IconButton!
    var cameraButton : IconButton!
    
    var configurationButton : IconButton!
    var infoButton : IconButton!

    var statusLabel : UILabel!
    var centerButton : IconButton!
    var refreshButton : IconButton!

    func fillMenu() {
        mapButton = MenuButton(icon: "map", menu: getMapMenu())
        menuView.addSubview(mapButton)
        markerButton = MenuButton(icon: "mappin", menu: getMarkerMenu())
        menuView.addSubview(markerButton)
        tourButton = MenuButton(icon: isTracking ? "figure.walk" : "figure.stand", menu: getTourMenu())
        menuView.addSubview(tourButton)
        
        searchButton = IconButton(icon: "magnifyingglass", tintColor: .white)
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchDown)
        menuView.addSubview(searchButton)
        cameraButton = IconButton(icon: "camera", tintColor: .white)
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        menuView.addSubview(cameraButton)
        
        configurationButton = IconButton(icon: "gearshape", tintColor: .white)
        configurationButton.addTarget(self, action: #selector(openConfiguration), for: .touchDown)
        menuView.addSubview(configurationButton)
        infoButton = IconButton(icon: "info.circle", tintColor: .white)
        infoButton.addTarget(self, action: #selector(openInfo), for: .touchDown)
        menuView.addSubview(configurationButton)
        menuView.addSubview(infoButton)

        mapButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .leading(menuView.leadingAnchor, inset: defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        markerButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .leading(mapButton.trailingAnchor, inset: 2 * defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        tourButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
            .leading(markerButton.trailingAnchor, inset: 2 * defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        
        searchButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .trailing(menuView.centerXAnchor, inset: defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        cameraButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .leading(menuView.centerXAnchor, inset: defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)

        infoButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .trailing(menuView.trailingAnchor, inset: defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        configurationButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .trailing(infoButton.leadingAnchor, inset: 2 * defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
    }

    func getMapMenu() -> UIMenu{
        let standardMapAction = UIAction(title: "defaultMapStyle".localize()) { action in
            self.setMapType(StandardMapType.instance)
        }
        let osmMapAction = UIAction(title: "openStreetMapStyle".localize()) { action in
            self.setMapType(OpenStreetMapType.instance)
        }
        let topoMapAction = UIAction(title: "openTopoMapStyle".localize()) { action in
            self.setMapType(OpenTopoMapType.instance)
        }
        let satelliteAction = UIAction(title: "satelliteMapStyle".localize()) { action in
            self.setMapType(SatelliteMapType.instance)
        }
        let preloadAction = UIAction(title: "preloadMap".localize(), image: UIImage(systemName: "square.and.arrow.down")) { action in
            self.preloadMap()
        }
        let configAction = UIAction(title: "mapConfiguration".localize(), image: UIImage(systemName: "gearshape")) { action in
            self.openMapConfiguration()
        }
        return UIMenu(title: "", children: [standardMapAction, osmMapAction, topoMapAction, satelliteAction, preloadAction, configAction])
    }
    
    func preloadMap(){
        print("preloadMap")
    }
    
    func openMapConfiguration(){
        let controller = MapConfigurationViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    func getMarkerMenu() -> UIMenu{
        let isShowingPins = Settings.instance.showMarkers
        let title = isShowingPins ? "hideMarkers" : "showMarkers"
        let img = isShowingPins ? UIImage(systemName: "mappin.slash") : UIImage(systemName: "mappin")
        let toggleAction = UIAction(title: title.localize(), image: img) { action in
            Settings.instance.showMarkers = !Settings.instance.showMarkers
            self.markerButton.menu = self.getMarkerMenu()
            self.updateMarkers()
        }
        let addAction = UIAction(title: "addMarker".localize(), image: UIImage(systemName: "mappin.and.ellipse")) { action in
            self.openAddMarker()
        }
        let searchAction = UIAction(title: "searchMarker".localize(), image: UIImage(systemName: "magnifyingglass")) { action in
            self.openSearchMarker()
        }
        return UIMenu(title: "", children: [toggleAction, addAction, searchAction])
    }
    
    func updateMarkers(){
        print("updateMarkers")
    }
    
    func openAddMarker(){
        let controller = MarkerViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    func openSearchMarker(){
        let controller = MarkerSearchViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    func getTourMenu() -> UIMenu {
        let title = self.isTracking ? "stopTracking" : "startTracking"
        let toggleAction = UIAction(title: title.localize(), image: UIImage(systemName: "figure.walk")) { action in
            self.isTracking = !self.isTracking
            self.tourButton.setImage(UIImage(systemName: self.isTracking ? "figure.walk" : "figure.stand"), for: .normal)
            self.tourButton.menu = self.getTourMenu()
        }
        let saveAction = UIAction(title: "saveTour".localize(), image: UIImage(systemName: "square.and.arrow.down")) { action in
            self.openSaveTour()
        }
        let searchAction = UIAction(title: "searchTour".localize(), image: UIImage(systemName: "magnifyingglass")) { action in
            self.openSearchTour()
        }
        return UIMenu(title: "", children: [toggleAction, saveAction, searchAction])
    }
    
    func openSearchTour(){
        let controller = TourSearchViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    func openSaveTour(){
        let controller = TourViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @objc func openSearch(){
        let controller = SearchViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }

    @objc func openCamera(){
        let controller = PhotoCaptureViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }

    @objc func openConfiguration(){
        let controller = ConfigurationViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @objc func openInfo(){
        let controller = InfoViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }

    func fillStatus() {
        statusLabel = UILabel()
        statusLabel.textColor = .white
        statusView.addSubview(statusLabel)
        centerButton = IconButton(icon: "smallcircle.fill.circle", tintColor: .white)
        centerButton.addTarget(self, action: #selector(centerMap), for: .touchDown)
        statusView.addSubview(centerButton)
        refreshButton = IconButton(icon: "arrow.triangle.2.circlepath", tintColor: .white)
        refreshButton.addTarget(self, action: #selector(refreshMap), for: .touchDown)
        statusView.addSubview(refreshButton)

        statusLabel.setAnchors()
                .top(statusView.topAnchor, inset: defaultInset)
                .centerX(statusView.centerXAnchor)
                .bottom(statusView.bottomAnchor)
        centerButton.setAnchors()
                .top(statusView.topAnchor, inset: defaultInset)
                .leading(statusLabel.trailingAnchor, inset: defaultInset)
                .bottom(statusView.bottomAnchor)
        refreshButton.setAnchors()
                .top(statusView.topAnchor, inset: defaultInset)
                .trailing(statusView.trailingAnchor, inset: defaultInset)
                .bottom(statusView.bottomAnchor)
    }
    
    @objc func centerMap(){
        if let loc = LocationService.shared.getLocation(){
            mapView.centerToLocation(loc)
        }
    }

    @objc func refreshMap(){
        if let renderer = tileOverlay?.renderer{
            renderer.reloadData()
        }
        else{
            mapView.setNeedsLayout()
        }
    }
    
    override func locationDidChange(location: Location){
        super.locationDidChange(location: location)
        updatePositionLabel()
        if isTracking{
            mapView.centerToLocation(location)
        }
    }
    
    func updatePositionLabel(){
        LocationService.shared.lookUpCurrentLocation()
        statusLabel.text = LocationService.shared.getLocationDescription()
    }

}
