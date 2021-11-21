/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation
import AVKit

class MapViewController: UIViewController {
    
    var mapView = MapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.fillView(view: view)
        let minZoom = MapController.minimumZoomLevelForViewSize(viewSize: mapView.bounds.size)
        mapView.setupScrollView(minimalZoom: minZoom)
        mapView.setupTileLayerView()
        mapView.setupTrackLayerView()
        mapView.setupUserLocationView()
        mapView.setupPlaceMarkersLayerView()
        mapView.placeMarkersLayerView.delegate = self
        mapView.setupControlLayerView()
        mapView.controlLayerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.connectLocationService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.disconnectLocationService()
    }
    
    private func assertPlace(coordinate: CLLocationCoordinate2D, onComplete: ((PlaceData) -> Void)? = nil){
        if let nextPlace = PlaceController.instance.placeNextTo(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){
            var txt = nextPlace.description
            if !txt.isEmpty{
                txt += ", "
            }
            txt += nextPlace.location.coordinateString
            showNegativeDecision(title: "useLocation".localize(), text: txt){ ok in
                if ok{
                    onComplete?(nextPlace)
                }
                else{
                    let place = PlaceController.instance.addPlace(coordinate: coordinate)
                    self.mapView.addPlaceMarker(place: place)
                    onComplete?(place)
                }
            }
        }
        else{
            let place = PlaceController.instance.addPlace(coordinate: coordinate)
            self.mapView.addPlaceMarker(place: place)
            onComplete?(place)
        }
    }
    
    private func assertPhotoPlace(coordinate: CLLocationCoordinate2D, onComplete: ((PlaceData) -> Void)? = nil){
        let location = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: MapController.minHorizontalAccuracy, verticalAccuracy: MapController.minVerticalAccuracy, timestamp: Date())
        if let nextPlace = PlaceController.instance.placeNextTo(location: location){
            onComplete?(nextPlace)
        }
        else{
            let place = PlaceController.instance.addPlace(coordinate: location.coordinate)
            self.mapView.addPlaceMarker(place: place)
            onComplete?(place)
        }
    }
    
}

extension MapViewController: PlaceMarkersLayerViewDelegate{
    
    func showPlaceDetails(place: PlaceData) {
        let controller = PlaceDetailViewController()
        controller.place = place
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func editPlaceData(place: PlaceData) {
        let controller = PlaceEditViewController()
        controller.place = place
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func deletePlace(place: PlaceData) {
        PlaceController.instance.removePlace(place)
        PlaceController.instance.save()
    }
    
}

extension MapViewController: ControlLayerDelegate{
    
    func focusUserLocation() {
        mapView.focusUserLocation()
    }
    
    func addPlace(){
        let coordinate = mapView.getVisibleCenterCoordinate()
        assertPlace(coordinate: coordinate){ place in
            
        }
    }
    
    func preloadMap() {
        let controller = MapPreloadViewController()
        controller.mapRegion = mapView.currentMapRegion
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openInfo() {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openCamera() {
        AVCaptureDevice.askCameraAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = PhotoData()
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
    
    func openTracking() {
        let controller = TrackViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func openPreferences(){
        let controller = MapPreferencesViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}

extension MapViewController: PreferencesDelegate{
    
    func clearTileCache() {
        MapTileFiles.clear()
    }
    
    func removePlaces() {
        PlaceController.instance.places.removeAll()
        mapView.placeMarkersLayerView.setupPlaceMarkers()
    }
    
}

extension MapViewController: PhotoCaptureDelegate{
    
    func photoCaptured(photo: PhotoData) {
        if let location = LocationService.shared.location{
            assertPhotoPlace(coordinate: location.coordinate){ place in
                place.addPhoto(photo: photo)
                PlaceController.instance.save()
            }
        }
    }
    
}

extension MapViewController: TrackDelegate{
    
    func trackLoaded() {
        mapView.trackLayerView.setNeedsDisplay()
    }

}