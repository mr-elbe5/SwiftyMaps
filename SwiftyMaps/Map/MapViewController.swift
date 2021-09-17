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
    var mapType : MapType = StandardMapType.instance
    var tileOverlay : MKTileOverlay? = nil
    var tileOverlayRenderer : MKTileOverlayRenderer? = nil
    var zoomLevel : Int = 0
    
    var appleLogoView : UIView? = nil
    var attributionLabel : UIView? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.delegate = self
        if LocationService.shared.authorized{
            initLocation()
        }
        if identifyAppleAttributions(){
            print("apple attributions identified")
        }
    }
    
    func initLocation(){
        if !locationInitialized, let loc = LocationService.shared.getLocation(){
            if Settings.instance.startWithLastPosition{
                mapView.loadLastRegion()
            }
            else{
                let region = MKCoordinateRegion(
                    center: loc.coordinate,
                    latitudinalMeters: Statics.startRadius,longitudinalMeters: Statics.startRadius)
                mapView.centerToLocation(region)
            }
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
    
    func identifyAppleAttributions() -> Bool{
        var found = false
        for vw in mapView.subviews {
            let vwType = "\(type(of: vw))"
            switch vwType {
            case "MKAppleLogoImageView":
                appleLogoView = vw
                found = true
            case "MKAttributionLabel":
                attributionLabel = vw
                found = true
            default:
                continue
            }
        }
        return found
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
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
        if overlay is MKTileOverlay, let renderer = mapType.getTileOverlayRenderer(overlay: overlay as! MKTileOverlay) {
            print("get tile renderer")
            self.tileOverlayRenderer = renderer
            return self.tileOverlayRenderer!
        } else {
            return MKOverlayRenderer()
        }
        
    }
    
    func setMapType(_ type: MapType){
        mapType = type
        if tileOverlay != nil{
            mapView.removeOverlay(tileOverlay!)
            tileOverlay = nil
            tileOverlayRenderer = nil
        }
        if mapType.usesTileOverlay, let overlay = mapType.getTileOverlay(){
            self.tileOverlay = overlay
            mapView.addOverlay(overlay, level: .aboveLabels)
        }
        mapView.setMkMapType(from: mapType)
        appleLogoView?.isHidden = !mapType.showsAppleLabel
        attributionLabel?.isHidden = !mapType.showsAppleLabel
        Settings.instance.mapTypeName = mapType.name
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}
