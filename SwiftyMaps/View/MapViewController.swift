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
    var overlay : MKTileOverlay? = nil;
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
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        let toggleStyleButton = IconButton(icon: "map")
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
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
    
    func locationDidChange(location: Location){
        //print("map loc = \(location.coordinate)")
        if self.location == nil{
            self.location = location
            mkMapView.centerToLocation(location, regionRadius: self.radius)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorized{
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
    
    @objc func toggleMapStyle() {
        switch mapType{
        case .standard:
            setMapType(.openStreetMap)
        case .openStreetMap:
            setMapType(.openTopoMap)
        case .openTopoMap:
            setMapType(.satellite)
        case .satellite:
            setMapType(.standard)
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
