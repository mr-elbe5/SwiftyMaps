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
    
    var mkMapView = MKMapView()
    var mapLoaded = false
    var location: Location? = nil
    var radius : CLLocationDistance = 10000
    var mapType : MKMapView.MapType = .standard
    var overlay : MKTileOverlay? = nil
    var zoomLevel : Int = 0
    
    var appleLogoView : UIView? = nil
    var attributionLabel : UIView? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationService.shared.authorized{
            if location == nil{
                location = LocationService.shared.getLocation()
                if let loc = location{
                    mkMapView.centerToLocation(loc, regionRadius: radius)
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
            setAnnotations()
        }
    }

    func setAnnotations(){

    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        for vw in mkMapView.subviews {
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

    func locationDidChange(location: Location){
        if self.location == nil{
            self.location = location
            mkMapView.centerToLocation(location, regionRadius: radius)
        }
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
    
    func setMapType(_ type: MKMapView.MapType){
        mapType = type
        if overlay != nil{
            mkMapView.removeOverlay(overlay!)
            overlay = nil
        }
        switch mapType{
        case .openStreetMap:
            setOverlay(with: "https://maps.elbe5.de/carto/{z}/{x}/{y}.png")
            overlay?.maximumZ = 20
        case .openTopoMap:
            setOverlay(with: "https://maps.elbe5.de/topo/{z}/{x}/{y}.png")
            overlay?.maximumZ = 17
        default:
            break
        }
        mkMapView.setMapType(mapType)
        let showAppleLabels = mkMapView.showAppleLabels(mapType)
        appleLogoView?.isHidden = !showAppleLabels
        attributionLabel?.isHidden = !showAppleLabels
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
    
}
