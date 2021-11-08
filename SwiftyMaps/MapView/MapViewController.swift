//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit


class MapViewController: UIViewController {
    
    /*var mapView = MKMapView()
    var mapLoaded = false
    var locationInitialized = false
    var mapType : MapType = StandardMapType.instance
    var tileOverlay : MapTileOverlay? = nil
    var zoomLevel : Double = 0
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
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
    
    func setMapType(_ type: MapType){
        mapType = type
        if tileOverlay != nil{
            mapView.removeOverlay(tileOverlay!)
            tileOverlay = nil
        }
        if mapType.usesTileOverlay, let overlay = mapType.getTileOverlay(){
            overlay.delegate = self
            self.tileOverlay = overlay
            mapView.addOverlay(overlay, level: .aboveLabels)
        }
        mapView.setMkMapType(from: mapType)
        mapView.setCameraZoomRange(mapType.zoomRange, animated: true)
        appleLogoView?.isHidden = !mapType.showsAppleLabel
        attributionLabel?.isHidden = !mapType.showsAppleLabel
        Settings.instance.mapTypeName = mapType.name
        Settings.instance.save()
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
    // LocationServiceDelegate
    
    func authorizationDidChange(authorized: Bool) {
        if authorized{
            initLocation()
        }
    }
    
    func locationDidChange(location: Location){
        
    }*/
    
}

/*extension MapViewController : MKMapViewDelegate{
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        setAnnotations()
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MapTileOverlay, let renderer = overlay.renderer{
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
    
}*/

/*extension MapViewController: MapTileOverlayDelegate{
    
    func zoomChanged(from: Int, to: Int) {
        print("zoom changed from \(from) to \(to), calculated zoom: \(mapView.zoomLevel), dist = \(round(mapView.camera.centerCoordinateDistance))")
        OSM.Tiles(minLongitude: mapView.region.minLongitude, maxLongitude: mapView.region.maxLongitude, minLatitude: mapView.region.minLatitude, maxLatitude: mapView.region.maxLatitude, zoom: to).dump()
    }
    
}*/

