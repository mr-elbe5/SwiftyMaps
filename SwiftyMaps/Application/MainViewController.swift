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
    
    var state : LocationState = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.fillView(view: view)
        MapStatics.minZoom = MapStatics.minimumZoomLevelForViewSize(viewSize: mapView.bounds.size)
        mapView.setupScrollView()
        mapView.setupTileLayerView()
        mapView.setupTrackLayerView()
        mapView.setupUserLocationView()
        mapView.setupPlaceLayerView()
        mapView.placeLayerView.delegate = self
        mapView.setupControlLayerView()
        mapView.controlLayerView.delegate = self
        mapView.setDefaultLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.delegate = self
    }
    
    // remove??
    override func viewWillDisappear(_ animated: Bool) {
        if !Tracks.instance.isTracking{
            LocationService.shared.delegate = nil
        }
    }
    
    private func assertPlace(coordinate: CLLocationCoordinate2D, onComplete: ((PlaceData) -> Void)? = nil){
        if let nextPlace = Places.instance.placeNextTo(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){
            var txt = nextPlace.description
            if !txt.isEmpty{
                txt += ", "
            }
            txt += nextPlace.location.coordinateString
            let alertController = UIAlertController(title: "useLocation".localize(), message: txt, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "no".localize(), style: .default) { action in
                let place = Places.instance.addPlace(coordinate: coordinate)
                self.mapView.addPlaceMarker(place: place)
                onComplete?(place)
            })
            alertController.addAction(UIAlertAction(title: "yes".localize(), style: .cancel) { action in
                onComplete?(nextPlace)
            })
            self.present(alertController, animated: true)
        }
        else{
            let place = Places.instance.addPlace(coordinate: coordinate)
            self.mapView.addPlaceMarker(place: place)
            onComplete?(place)
        }
    }
    
    private func assertPhotoPlace(coordinate: CLLocationCoordinate2D, onComplete: ((PlaceData) -> Void)? = nil){
        let location = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: Preferences.instance.minHorizontalAccuracy, verticalAccuracy: Preferences.instance.minVerticalAccuracy, timestamp: Date())
        if let nextPlace = Places.instance.placeNextTo(location: location){
            onComplete?(nextPlace)
        }
        else{
            let place = Places.instance.addPlace(coordinate: location.coordinate)
            self.mapView.addPlaceMarker(place: place)
            onComplete?(place)
        }
    }
    
    func debug(_ text: String){
        mapView.debug(text)
    }
    
}

extension MainViewController: LocationServiceDelegate{
    
    func authorizationDidChange(authorized: Bool, location: CLLocation?) {
        if authorized, let loc = location, state == .none{
            state = loc.horizontalAccuracy <= Preferences.instance.minHorizontalAccuracy ? .exact : .rough
            mapView.stateDidChange(from: .none, to: state, location: loc)
        }
    }
    
    func locationDidChange(location: CLLocation) {
        switch state{
        case .none:
            debug("none")
            state = location.horizontalAccuracy <= Preferences.instance.minHorizontalAccuracy ? .exact : .rough
            mapView.stateDidChange(from: .none, to: state, location: location)
        case .rough:
            debug("rough")
            if location.horizontalAccuracy <= Preferences.instance.minHorizontalAccuracy{
                state = .exact
                mapView.stateDidChange(from: .rough, to: state, location: location)
            }
        case .exact:
            debug("exact")
            mapView.locationDidChange(location: location)
        }
    }
    
    func directionDidChange(direction: CLLocationDirection) {
        mapView.setDirection(direction)
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
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func deletePlace(place: PlaceData) {
        showApprove(title: "confirmDeletePlace".localize(), text: "deletePlaceHint".localize()){
            Places.instance.deletePlace(place)
            Places.instance.save()
        }
    }
    
}

extension MainViewController: ControlLayerDelegate{
    
    func preloadMap() {
        let region = mapView.currentMapRegion
        if region.size > Preferences.instance.maxPreloadTiles{
            let text = "preloadMapsAlert".localize(param1: String(region.size), param2: String(Preferences.instance.maxPreloadTiles))
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
            MapTiles.clear()
        }
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
        Preferences.instance.showPins = show
        mapView.placeLayerView.isHidden = !Preferences.instance.showPins
    }
    
    func deletePlaces() {
        showApprove(title: "confirmDeletePlaces".localize(), text: "deletePlacesHint".localize()){
            Places.instance.deleteAllPlaces()
            self.mapView.placeLayerView.setupPlaceMarkers()
        }
    }
    
    func startTracking(){
        Tracks.instance.startTracking()
        mapView.trackLayerView.showCurrentTrack()
        mapView.controlLayerView.startTracking()
    }
    
    func openCurrentTrack() {
        let controller = CurrentTrackViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func hideTrack() {
        mapView.trackLayerView.hideTrack()
    }
    
    func openTrackList() {
        let controller = TrackListViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func deleteTracks() {
        showApprove(title: "confirmDeleteTracks".localize(), text: "deleteTracksHint".localize()){
            Tracks.instance.deleteAllTracks()
            self.mapView.trackLayerView.setNeedsDisplay()
        }
    }
    
    func focusUserLocation() {
        mapView.focusUserLocation()
    }
    
    func openInfo() {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func openPreferences() {
        let controller = PreferencesViewController()
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
        if let location = LocationService.shared.lastLocation{
            assertPhotoPlace(coordinate: location.coordinate){ place in
                let changeState = place.photos.isEmpty
                place.addPhoto(photo: photo)
                Places.instance.save()
                if changeState{
                    DispatchQueue.main.async {
                        print("changeState")
                        self.mapView.placeLayerView.updatePlaceState(place)
                    }
                }
            }
        }
    }
    
}

extension MainViewController: PlaceEditDelegate{
    
    func updatePlaceState(place: PlaceData) {
        mapView.placeLayerView.updatePlaceState(place)
    }
    
}

extension MainViewController: CurrentTrackDelegate{
    
    func pauseCurrentTrack() {
        Tracks.instance.pauseTracking()
        mapView.controlLayerView.pauseTrackInfo()
    }
    
    func resumeCurrentTrack() {
        Tracks.instance.resumeTracking()
        mapView.controlLayerView.resumeTrackInfo()
    }
    
    func cancelCurrentTrack() {
        Tracks.instance.cancelCurrentTrack()
        mapView.trackLayerView.hideTrack()
        mapView.controlLayerView.stopTracking()
    }
    
    func saveCurrentTrack() {
        let alertController = UIAlertController(title: "name".localize(), message: "nameOrDescriptionHint".localize(), preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
            if let track = Tracks.instance.currentTrack{
                track.description = alertController.textFields![0].text ?? "Route"
                Tracks.instance.saveTrackCurrentTrack()
            }
            self.mapView.controlLayerView.stopTracking()
        })
        present(alertController, animated: true)
    }
    
}

extension MainViewController: TrackListDelegate{
    
    func showOnMap(track: TrackData) {
        mapView.trackLayerView.showTrack(track: track)
        mapView.scrollToCenteredCoordinate(coordinate: track.startLocation.coordinate)
    }
    
    
    func updateTrackLayer() {
        mapView.trackLayerView.setNeedsDisplay()
    }

}

extension MainViewController: PlaceListDelegate{
    
    func showOnMap(place: PlaceData) {
        mapView.scrollToCenteredCoordinate(coordinate: place.location.coordinate)
    }
    
    
    func updatePlaceLayer() {
        mapView.placeLayerView.setNeedsDisplay()
    }

}

