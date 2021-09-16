//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit
import MapKit
import SwiftyIOSViewExtensions

class MapViewController: UIViewController, MKMapViewDelegate, LocationServiceDelegate {
    
    var mapView = MKMapView()
    var mapLoaded = false
    var locationInitialized = false
    var radius : CLLocationDistance = 10000
    var mapType : MapType = StandardMapType()
    var overlay : MKTileOverlay? = nil
    var zoomLevel : Int = 0
    
    var appleLogoView : UIView? = nil
    var attributionLabel : UIView? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.delegate = self
        if LocationService.shared.authorized{
            initLocation()
        }
    }
    
    func initLocation(){
        if !locationInitialized, let loc = LocationService.shared.getLocation(){
            mapView.centerToLocation(loc, regionRadius: radius)
            locationInitialized = true
            locationDidChange(location: loc)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
    }
    
    func setNeedsUpdate(){
        if mapLoaded{
            mapView.removeAnnotations(mapView.annotations)
            setAnnotations()
        }
    }

    func setAnnotations(){

    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        for vw in mapView.subviews {
            let vwType = "\(type(of: vw))"
            switch vwType {
            case "MKAppleLogoImageView":
                appleLogoView = vw
            case "MKAttributionLabel":
                attributionLabel = vw
            default:
                continue
            }
        }
        setAnnotations()
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let zoom = mapView.zoomLevel
        if zoom != zoomLevel{
            zoomLevel = zoom
            print("\(zoomLevel), \(mapView.camera.centerCoordinateDistance)")
        }
    }
    
    func authorizationDidChange(authorized: Bool) {
        if authorized{
            initLocation()
        }
    }

    func locationDidChange(location: Location){
        
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
        if overlay != nil{
            mapView.removeOverlay(overlay!)
            overlay = nil
        }
        if mapType.usesTileOverlay, let overlay = mapType.getTileOverlay(){
            self.overlay = overlay
            mapView.addOverlay(overlay, level: .aboveLabels)
        }
        mapView.setMkMapType(from: mapType)
        appleLogoView?.isHidden = !mapType.showsAppleLabel
        attributionLabel?.isHidden = !mapType.showsAppleLabel
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}
