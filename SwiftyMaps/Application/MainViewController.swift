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
            let alertController = UIAlertController(title: "useLocation".localize(), message: txt, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "no".localize(), style: .default) { action in
                let place = PlaceController.instance.addPlace(coordinate: coordinate)
                self.mapView.addPlaceMarker(place: place)
                onComplete?(place)
            })
            alertController.addAction(UIAlertAction(title: "yes".localize(), style: .cancel) { action in
                onComplete?(nextPlace)
            })
            self.present(alertController, animated: true)
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

extension MainViewController: PlaceMarkersLayerViewDelegate{
    
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

extension MainViewController: ControlLayerDelegate{
    
    func focusUserLocation() {
        mapView.focusUserLocation()
    }
    
    func addPlace(){
        let coordinate = mapView.getVisibleCenterCoordinate()
        assertPlace(coordinate: coordinate){ place in
            
        }
    }
    
    func preloadMap() {
        let region = mapView.currentMapRegion
        if region.size > MapController.maxPreloadTiles{
            let text = "preloadMapsAlert".localize(param1: String(region.size), param2: String(MapController.maxPreloadTiles))
            showAlert(title: "pleaseNote".localize(), text: text, onOk: nil)
        }
        else{
            let controller = MapPreloadViewController()
            controller.mapRegion = region
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
    }
    
    func deleteTiles() {
        showApprove(title: "reallyClearTileCache".localize(), text: "clearTileCacheHint".localize()){
            MapTileFiles.clear()
        }
    }
    
    func openMapPreferences() {
        let controller = MapPreferencesViewController()
        controller.delegate = self
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
    
    func openCurrentTrack() {
        let controller = TrackViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func openTrackList() {
        let controller = TrackViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func openTrackingPreferences() {
        let controller = TrackViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func openGeneralPreferences(){
        let controller = GeneralPreferencesViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}

extension MainViewController: MapPreferencesDelegate{
    
    func clearTileCache() {
        MapTileFiles.clear()
    }
    
}

extension MainViewController: GeneralPreferencesDelegate{
    
    func removePlaces() {
        PlaceController.instance.places.removeAll()
        mapView.placeMarkersLayerView.setupPlaceMarkers()
    }
    
}

extension MainViewController: PhotoCaptureDelegate{
    
    func photoCaptured(photo: PhotoData) {
        if let location = LocationService.shared.location{
            assertPhotoPlace(coordinate: location.coordinate){ place in
                place.addPhoto(photo: photo)
                PlaceController.instance.save()
            }
        }
    }
    
}

extension MainViewController: TrackDelegate{
    
    func trackLoaded() {
        mapView.trackLayerView.setNeedsDisplay()
    }

}