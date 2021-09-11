//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit
import MapKit
import SwiftyIOSViewExtensions

enum MapType: String{
    case standard
    case openStreetMap
    case openTopoMap
    case satellite
}

class MapViewController: UIViewController, MKMapViewDelegate, LocationServiceDelegate {
    
    var headerView = UIView()
    var mkMapView = MKMapView()
    var mapLoaded = false
    var location: Location? = nil
    var radius : CLLocationDistance = 10000
    var mapType : MapType = .standard
    var overlay : MKTileOverlay? = nil
    var zoomLevel : Int = 0
    
    let zoomRangeDefault = MKMapView.CameraZoomRange(minCenterCoordinateDistance: -1, maxCenterCoordinateDistance: -1)
    let zoomRange20 = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 175, maxCenterCoordinateDistance: -1)
    let zoomRange17 = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1380, maxCenterCoordinateDistance: -1)
    
    var appleLogoView : UIView? = nil
    var attributionLabel : UIView? = nil
    
    override func loadView() {
        super.loadView()
        LocationService.shared.checkRunning()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(guide.topAnchor,inset: .zero)
            .trailing(guide.trailingAnchor,inset: .zero)
        headerView.backgroundColor = .black
        let styleButton = IconButton(icon: "map")
        styleButton.tintColor = .white
        styleButton.menu = getStyleMenu()
        styleButton.showsMenuAsPrimaryAction = true
        headerView.addSubview(styleButton)
        styleButton.setAnchors()
            .top(headerView.topAnchor, inset: defaultInset)
            .leading(headerView.leadingAnchor, inset: defaultInset)
            .bottom(headerView.bottomAnchor, inset: defaultInset)
        let pinButton = IconButton(icon: "mappin")
        pinButton.tintColor = .white
        pinButton.menu = getPinMenu()
        pinButton.showsMenuAsPrimaryAction = true
        headerView.addSubview(pinButton)
        pinButton.setAnchors()
            .top(headerView.topAnchor, inset: defaultInset)
            .leading(styleButton.trailingAnchor, inset: 2 * defaultInset)
            .bottom(headerView.bottomAnchor, inset: defaultInset)
        let tourButton = IconButton(icon: "figure.walk")
        tourButton.tintColor = .white
        tourButton.menu = getTourMenu()
        tourButton.showsMenuAsPrimaryAction = true
        headerView.addSubview(tourButton)
        tourButton.setAnchors()
            .top(headerView.topAnchor, inset: defaultInset)
            .leading(pinButton.trailingAnchor, inset: 2 * defaultInset)
            .bottom(headerView.bottomAnchor, inset: defaultInset)
        let cameraButton = IconButton(icon: "camera")
        cameraButton.tintColor = .white
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        headerView.addSubview(cameraButton)
        cameraButton.setAnchors()
            .top(headerView.topAnchor, inset: defaultInset)
            .centerX(headerView.centerXAnchor)
            .bottom(headerView.bottomAnchor, inset: defaultInset)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.tintColor = .white
        infoButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        headerView.addSubview(infoButton)
        infoButton.setAnchors()
            .top(headerView.topAnchor, inset: defaultInset)
            .trailing(headerView.trailingAnchor, inset: defaultInset)
            .bottom(headerView.bottomAnchor, inset: defaultInset)
        let configButton = IconButton(icon: "slider.horizontal.3")
        configButton.tintColor = .white
        configButton.menu = getConfigMenu()
        configButton.showsMenuAsPrimaryAction = true
        headerView.addSubview(configButton)
        configButton.setAnchors()
            .top(headerView.topAnchor, inset: defaultInset)
            .trailing(infoButton.leadingAnchor, inset: 2 * defaultInset)
            .bottom(headerView.bottomAnchor, inset: defaultInset)
        mkMapView.mapType = .standard
        mkMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mkMapView.delegate = self
        view.addSubview(mkMapView)
        mkMapView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView.bottomAnchor, inset: 1)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
    }
    
    func getStyleMenu() -> UIMenu{
        let standardMapAction = UIAction(title: "defaultMapStyle".localize()) { action in
            self.setMapType(.standard)
        }
        let osmMapAction = UIAction(title: "openStreetMapStyle".localize()) { action in
            self.setMapType(.openStreetMap)
        }
        let topoMapAction = UIAction(title: "openTopoMapStyle".localize()) { action in
            self.setMapType(.openTopoMap)
        }
        let satelliteAction = UIAction(title: "satelliteMapStyle".localize()) { action in
            self.setMapType(.satellite)
        }
        return UIMenu(title: "", children: [standardMapAction, osmMapAction, topoMapAction, satelliteAction])
    }
    
    func getPinMenu() -> UIMenu{
        let setPinAction = UIAction(title: "setPin".localize(), image: UIImage(systemName: "mappin.and.ellipse")) { action in
            self.setPin()
        }
        let removePinAction = UIAction(title: "removePin".localize(), image: UIImage(systemName: "mappin.slash")) { action in
            self.removePin()
        }
        return UIMenu(title: "", children: [setPinAction, removePinAction])
        
    }
    
    func getTourMenu() -> UIMenu{
        let startTourAction = UIAction(title: "startTour".localize(), image: UIImage(systemName: "figure.walk")) { action in
            self.startTour()
        }
        let stopTourAction = UIAction(title: "stopTour".localize(), image: UIImage(systemName: "figure.stand")) { action in
            self.stopTour()
        }
        return UIMenu(title: "", children: [startTourAction, stopTourAction])
        
    }
    
    func getConfigMenu() -> UIMenu{
        let settingsAction = UIAction(title: "settings".localize(), image: UIImage(systemName: "gearshape")) { action in
            self.openSettings()
        }
        let exportAction = UIAction(title: "export".localize(), image: UIImage(systemName: "square.and.arrow.up")) { action in
            self.openExport()
        }
        return UIMenu(title: "", children: [settingsAction, exportAction])
        
    }
    
    func locationDidChange(location: Location){
        //print("map loc = \(location.coordinate)")
        if self.location == nil{
            self.location = location
            mkMapView.centerToLocation(location, regionRadius: self.radius)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationService.shared.authorized{
            if location == nil{
                location = LocationService.shared.getLocation()
                if let loc = location{
                    self.mkMapView.centerToLocation(loc, regionRadius: self.radius)
                }
            }
            LocationService.shared.delegate = self
        }
        else{
            showError("locationNotAuthorized")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
    }
    
    func setNeedsUpdate(){
        if mapLoaded{
            mkMapView.removeAnnotations(mkMapView.annotations)
            assertMapPins()
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        identifyLabels()
        assertMapPins()
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let zoom = mapView.zoomLevel
        if zoom != zoomLevel{
            zoomLevel = zoom
            print("zoomLevel: \(zoomLevel)")
        }
    }
    
    func identifyLabels(){
        for vw in mkMapView.subviews{
            let vwType = "\(type(of: vw))"
            switch vwType{
            case "MKAppleLogoImageView":
                appleLogoView = vw
            case "MKAttributionLabel":
                attributionLabel = vw
            default:
                continue
            }
        }
    }
    
    func assertMapPins(){
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        } else {
            return MKTileOverlayRenderer()
        }
    }
    
    func setMapType(_ type: MapType){
        mapType = type
        removeOverlay()
        switch mapType{
        case .standard:
            mkMapView.mapType = .standard
            mkMapView.setCameraZoomRange(zoomRangeDefault, animated: true)
            appleLogoView?.isHidden = false
            attributionLabel?.isHidden = false
        case .openStreetMap:
            mkMapView.mapType = .standard
            setOverlay(with: "https://maps.elbe5.de/carto/{z}/{x}/{y}.png")
            overlay?.maximumZ = 20
            mkMapView.setCameraZoomRange(zoomRange20, animated: true)
            appleLogoView?.isHidden = true
            attributionLabel?.isHidden = true
        case .openTopoMap:
            mkMapView.mapType = .standard
            setOverlay(with: "https://maps.elbe5.de/topo/{z}/{x}/{y}.png")
            overlay?.maximumZ = 17
            mkMapView.setCameraZoomRange(zoomRange17, animated: true)
            appleLogoView?.isHidden = true
            attributionLabel?.isHidden = true
        case .satellite:
            mkMapView.mapType = .satellite
            mkMapView.setCameraZoomRange(zoomRangeDefault, animated: true)
            appleLogoView?.isHidden = false
            attributionLabel?.isHidden = false
        }
    }
    
    func setPin(){
        
    }
    
    func removePin(){
        
    }
    
    func startTour(){
        
    }
    
    func stopTour(){
        
    }
    
    @objc func openCamera(){
    
    }
    
    func openSettings(){
    
    }
    
    func openExport(){
    
    }
    
    private func removeOverlay(){
        if overlay != nil{
            mkMapView.removeOverlay(overlay!)
            overlay = nil
        }
    }
    
    private func setOverlay(with urlTemplate: String){
        let newOverlay = MKTileOverlay(urlTemplate: urlTemplate)
        newOverlay.canReplaceMapContent = true
        mkMapView.addOverlay(newOverlay, level: .aboveLabels)
        overlay = newOverlay
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
    func takeScreenshot(callback: @escaping (Result<UIImage, Error>) -> Void){
        let options = MKMapSnapshotter.Options()
        options.camera = self.mkMapView.camera
        options.region = self.mkMapView.region
        options.mapType = self.mkMapView.mapType
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if error != nil {
                print("Unable to create a map snapshot.")
                callback(.failure(error!))
            } else if let snapshot = snapshot {
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: CGPoint.zero)
                self.drawPins()
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                callback(.success(compositeImage!))
            }
        }
    }
    
    private func drawPins(){
        
    }
    
    private func drawPin(point: CGPoint, annotation: MKAnnotation) {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "snapshotUserPosition")
        annotationView.contentMode = .scaleAspectFit
        annotationView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        annotationView.drawHierarchy(in: CGRect(
            x: point.x - annotationView.bounds.size.width / 2.0,
            y: point.y - annotationView.bounds.size.height,
            width: annotationView.bounds.width,
            height: annotationView.bounds.height), afterScreenUpdates: true)
    }
    
}
