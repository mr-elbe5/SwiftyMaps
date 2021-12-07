/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
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
        mapView.setupLocationLayerView()
        mapView.locationLayerView.delegate = self
        mapView.setupControlLayerView()
        mapView.controlLayerView.delegate = self
        mapView.setDefaultLocation()
        LocationService.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.delegate = self
    }
    
    // remove??
    override func viewWillDisappear(_ animated: Bool) {
        if !ActiveTrack.isTracking{
            LocationService.shared.delegate = nil
        }
    }
    
    func debug(_ text: String){
        mapView.debug(text)
    }
    
}

extension MainViewController: LocationServiceDelegate{
    
    func authorizationDidChange(authorized: Bool, location: CLLocation?) {
        if authorized, let loc = location, state == .none{
            state = loc.horizontalAccuracy <= Preferences.instance.minLocationAccuracy ? .exact : .estimated
            mapView.stateDidChange(from: .none, to: state, location: loc)
        }
    }
    
    func locationDidChange(location: CLLocation) {
        switch state{
        case .none:
            state = location.horizontalAccuracy <= Preferences.instance.minLocationAccuracy ? .exact : .estimated
            mapView.stateDidChange(from: .none, to: state, location: location)
        case .estimated:
            if location.horizontalAccuracy <= Preferences.instance.minLocationAccuracy{
                state = .exact
                mapView.stateDidChange(from: .estimated, to: state, location: location)
            }
        case .exact:
            mapView.locationDidChange(location: location)
        }
    }
    
    func directionDidChange(direction: CLLocationDirection) {
        mapView.setDirection(direction)
    }
    
}

extension MainViewController: LocationLayerViewDelegate{
    
    func showLocationDetails(location: Location) {
        let controller = LocationDetailViewController()
        controller.location = location
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func showLocationGroupDetails(locationGroup: LocationGroup) {
        mapView.setZoom(zoom: MapStatics.maxZoom, animated: true)
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
    
    func addLocation(){
        print("MainViewController.addLocation")
        let coordinate = mapView.getVisibleCenterCoordinate()
        assertLocation(coordinate: coordinate){ location in
            self.updateLocationLayer()
        }
    }
    
    func openLocationList() {
        let controller = LocationListViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func showLocations(_ show: Bool) {
        Preferences.instance.showPins = show
        mapView.locationLayerView.isHidden = !Preferences.instance.showPins
    }
    
    func deleteLocations() {
        showApprove(title: "confirmDeleteLocations".localize(), text: "deleteLocationsHint".localize()){
            Locations.deleteAllLocations()
            self.updateLocationLayer()
        }
    }
    
    func startTracking(){
        if let lastLocation = LocationService.shared.lastLocation{
            assertLocation(coordinate: lastLocation.coordinate){ location in
                ActiveTrack.startTracking(startLocation: location)
                if let track = ActiveTrack.track{
                    self.mapView.trackLayerView.setTrack(track: track)
                    self.mapView.controlLayerView.startTrackControl()
                }
            }
        }
    }
    
    func openTrack(track: TrackData) {
        let controller = TrackDetailViewController()
        controller.track = track
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func hideTrack() {
        mapView.trackLayerView.setTrack(track: nil)
    }
    
    func openTrackList() {
        let controller = TrackListViewController()
        controller.tracks = Locations.getAllTracks()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func deleteTracks() {
        showApprove(title: "confirmDeleteTracks".localize(), text: "deleteTracksHint".localize()){
            Locations.deleteAllTracks()
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
            assertLocation(coordinate: location.coordinate){ location in
                let changeState = location.photos.isEmpty
                location.addPhoto(photo: photo)
                Locations.save()
                if changeState{
                    DispatchQueue.main.async {
                        self.updateLocationLayer()
                    }
                }
            }
        }
    }
    
}

extension MainViewController: LocationEditDelegate{
    
    func updateLocationLayer() {
        mapView.updateLocationLayer()
    }
    
}

extension MainViewController: LocationListDelegate{
    
    func showOnMap(location: Location) {
        mapView.scrollToCenteredCoordinate(coordinate: location.coordinate)
    }
    
    func deleteLocation(location: Location) {
        Locations.deleteLocation(location)
        Locations.save()
        updateLocationLayer()
    }

}

extension MainViewController: TrackDetailDelegate, TrackListDelegate{
    
    func viewTrackDetails(track: TrackData) {
        let trackController = TrackViewController()
        trackController.track = track
        trackController.modalPresentationStyle = .fullScreen
        self.present(trackController, animated: true)
    }
    
    func deleteTrack(track: TrackData, approved: Bool) {
        if approved{
            deleteTrack(track: track)
        }
        else{
            showApprove(title: "confirmDeleteTrack".localize(), text: "deleteTrackInfo".localize()){
                self.deleteTrack(track: track)
                //pin change
            }
        }
    }
    
    private func deleteTrack(track: TrackData){
        Locations.deleteTrack(track: track)
    }
    
    func viewTrack(track: TrackData) {
        let trackController = TrackViewController()
        trackController.track = track
        trackController.modalPresentationStyle = .fullScreen
        self.present(trackController, animated: true)
    }
    
    func showTrackOnMap(track: TrackData) {
        if let startLocation = track.startLocation{
            mapView.trackLayerView.setTrack(track: track)
            mapView.scrollToCenteredCoordinate(coordinate: startLocation.coordinate)
        }
    }
    
    func updateTrackLayer() {
        mapView.trackLayerView.setNeedsDisplay()
    }
    
    func pauseActiveTrack() {
        ActiveTrack.pauseTracking()
        mapView.controlLayerView.pauseTrackInfo()
    }
    
    func resumeActiveTrack() {
        ActiveTrack.resumeTracking()
        mapView.controlLayerView.resumeTrackInfo()
    }
    
    func cancelActiveTrack() {
        ActiveTrack.stopTracking()
        mapView.trackLayerView.setTrack(track: nil)
        mapView.controlLayerView.stopTrackControl()
    }
    
    func saveActiveTrack() {
        if let track = ActiveTrack.track{
            let alertController = UIAlertController(title: "name".localize(), message: "nameOrDescriptionHint".localize(), preferredStyle: .alert)
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
                track.description = alertController.textFields![0].text ?? "Route"
                track.startLocation.addTrack(track: track)
                Locations.save()
                self.mapView.trackLayerView.setTrack(track: track)
                ActiveTrack.stopTracking()
                self.mapView.controlLayerView.stopTrackControl()
                self.mapView.updateLocationLayer()
            })
            present(alertController, animated: true)
        }
    }
    
}


