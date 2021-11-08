/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var mapView = MapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.fillView(view: view)
        let minZoom = MapCalculator.minimumZoomLevelForViewSize(viewSize: mapView.bounds.size)
        mapView.setupScrollView(minimalZoom: minZoom)
        mapView.setupContentView()
        mapView.setupUserLocationView()
        mapView.setupAnnotationView()
        mapView.annotationView.delegate = self
        mapView.setupControlView()
        mapView.controlView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.connectLocationService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.disconnectLocationService()
    }
    
}

extension MainViewController: MapAnnotationViewDelegate{
    
    func showAnnotation(annotation: MapAnnotation) {
        let controller = MapAnnotationViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func editAnnotation(annotation: MapAnnotation) {
        let controller = EditAnnotationViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func deleteAnnotation(annotation: MapAnnotation) {
        MapAnnotationCache.instance.removeAnnotation(annotation)
        MapAnnotationCache.instance.save()
    }
    
}

extension MainViewController: MapControlDelegate{
    
    func focusUserLocation() {
        mapView.focusUserLocation()
    }
    
    func addAnnotationAtCross(){
        let annotation = MapAnnotationCache.instance.addAnnotation(coordinate: mapView.getVisibleCenterCoordinate())
        mapView.addAnnotation(annotation: annotation)
    }
    
    func addAnnotationAtUserPosition(){
        if let location = LocationService.shared.location{
            let annotation = MapAnnotation(coordinate: location.coordinate)
            mapView.addAnnotation(annotation: annotation)
        }
    }
    
    func changeMap(){
        if MapType.current.name == MapType.carto.name{
            MapType.current = .topo
        }
        else{
            MapType.current = .carto
        }
    }
    
    func openInfo() {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openCamera() {
        let controller = PhotoViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openTour() {
        let controller = TourViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openSearch() {
        let controller = SearchViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openPreferences(){
        let controller = MapPreferencesViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}

extension MainViewController: PreferencesDelegate{
    
    func clearTileCache() {
        MapTileCache.clear()
    }
    
    func removeAnnotations() {
        MapAnnotationCache.instance.annotations.removeAll()
        mapView.annotationView.setupAnnotations()
    }
    
}
