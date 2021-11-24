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
        mapView.setupPlaceLayerView()
        mapView.placeLayerView.delegate = self
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

extension MainViewController: PlaceLayerViewDelegate{
    
    func showPlaceDetails(place: PlaceData) {
        let controller = PlaceViewController()
        controller.place = place
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func editPlace(place: PlaceData) {
        let controller = PlaceEditViewController()
        controller.place = place
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func deletePlace(place: PlaceData) {
        showApprove(title: "confirmDeletePlace".localize(), text: "deletePlaceHint".localize()){
            PlaceController.instance.deletePlace(place)
            PlaceController.instance.save()
        }
    }
    
}

extension MainViewController: ControlLayerDelegate{
    
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
        showApprove(title: "confirmDeleteTiles".localize(), text: "deleteTilesHint".localize()){
            MapTileFiles.clear()
        }
    }
    
    func openMapPreferences() {
        let controller = MapPreferencesViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func addPlace(){
        let coordinate = mapView.getVisibleCenterCoordinate()
        assertPlace(coordinate: coordinate){ place in
            
        }
    }
    
    func openPlaceList() {
        let controller = PlaceListViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func showPlaces(_ show: Bool) {
        MapPreferences.instance.showPlaceMarkers = show
        mapView.placeLayerView.isHidden = !MapPreferences.instance.showPlaceMarkers
    }
    
    func deletePlaces() {
        showApprove(title: "confirmDeletePlaces".localize(), text: "deletePlacesHint".localize()){
            PlaceController.instance.deleteAllPlaces()
            self.mapView.placeLayerView.setupPlaceMarkers()
        }
    }
    
    func openCurrentTrack() {
        let controller = CurrentTrackViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func openTrackList() {
        let controller = TrackListViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func deleteTracks() {
        showApprove(title: "confirmDeleteTracks".localize(), text: "deleteTracksHint".localize()){
            TrackController.instance.deleteAllTracks()
            self.mapView.trackLayerView.setNeedsDisplay()
        }
    }
    
    func openTrackingPreferences() {
        let controller = TrackPreferencesViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func focusUserLocation() {
        mapView.focusUserLocation()
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

extension MainViewController: CurrentTrackDelegate{
    
    func pauseCurrentTrack() {
        TrackController.instance.pauseTracking()
        mapView.controlLayerView.stopTrackInfo()
    }
    
    func resumeCurrentTrack() {
        TrackController.instance.resumeTracking()
        mapView.controlLayerView.startTrackInfo()
    }
    
    func cancelCurrentTrack() {
        TrackController.instance.cancelCurrentTrack()
        mapView.controlLayerView.stopTrackInfo()
    }
    
    func saveCurrentTrack() {
        let alertController = UIAlertController(title: "name".localize(), message: "nameOrDescriptionHint".localize(), preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
            if let track = TrackController.instance.activeTrack{
                track.description = alertController.textFields![0].text ?? "Route"
                TrackController.instance.saveTrackCurrentTrack()
            }
            self.mapView.controlLayerView.stopTrackInfo()
        })
        present(alertController, animated: true)
    }
    
}

extension MainViewController: TrackListDelegate{
    
    func showOnMap(track: TrackData) {
        TrackController.instance.currentTrack = track
        mapView.trackLayerView.setNeedsDisplay()
        mapView.scrollToCenteredCoordinate(coordinate: track.startLocation.coordinate)
    }
    
    
    func updateTrackLayer() {
        mapView.trackLayerView.setNeedsDisplay()
    }

}

extension MainViewController: TrackPreferencesDelegate{

}

extension MainViewController: PlaceListDelegate{
    
    func showOnMap(place: PlaceData) {
        mapView.scrollToCenteredCoordinate(coordinate: place.location.coordinate)
    }
    
    
    func updatePlaceLayer() {
        mapView.placeLayerView.setNeedsDisplay()
    }

}
