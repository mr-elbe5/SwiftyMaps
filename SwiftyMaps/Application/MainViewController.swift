/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation
import AVKit

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
        controller.annotation = annotation
        present(controller, animated: true)
    }
    
    func editAnnotation(annotation: MapAnnotation) {
        let controller = EditAnnotationViewController()
        controller.annotation = annotation
        
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
        mapView.mapTypeHasChanged()
    }
    
    func openInfo() {
        let controller = InfoViewController()
        present(controller, animated: true)
    }
    
    func openCamera() {
        AVCaptureDevice.askCameraAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = MapAnnotationPhoto()
                    let imageCaptureController = PhotoCaptureViewController()
                    imageCaptureController.data = data
                    imageCaptureController.delegate = self
                    imageCaptureController.modalPresentationStyle = .fullScreen
                    self.present(imageCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showAlert(title: "error".localize(), text: "cameraNotAuthorized".localize())
                }
                return
            }
        }
    }
    
    func openTour() {
        let controller = TourViewController()
        present(controller, animated: true)
    }
    
    func openSearch() {
        let controller = SearchViewController()
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

extension MainViewController: PhotoCaptureDelegate{
    
    func photoCaptured(photo: MapAnnotationPhoto) {
        print("photo captured")
        //todo
    }
    
}
