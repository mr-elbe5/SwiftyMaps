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
        mapView.setupLocationLayerView()
        mapView.locationLayerView.delegate = self
        
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
    
    private func assertLocation(coordinate: CLLocationCoordinate2D, askForNext: Bool = false, onComplete: ((Location) -> Void)? = nil){
        if let nextLocation = Locations.instance.locationNextTo(coordinate: coordinate, maxDistance: Preferences.instance.maxLocationMergeDistance){
            if askForNext{
                var txt = nextLocation.description
                if !txt.isEmpty{
                    txt += ", "
                }
                txt += nextLocation.coordinateString
                let alertController = UIAlertController(title: "useLocation".localize(), message: txt, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "no".localize(), style: .default) { action in
                    let location = Locations.instance.addLocation(coordinate: coordinate)
                    self.mapView.addLocationMarker(location: location)
                    onComplete?(location)
                })
                alertController.addAction(UIAlertAction(title: "yes".localize(), style: .cancel) { action in
                    onComplete?(nextLocation)
                })
                self.present(alertController, animated: true)
            }
            else{
                onComplete?(nextLocation)
            }
        }
        else{
            let location = Locations.instance.addLocation(coordinate: coordinate)
            self.mapView.addLocationMarker(location: location)
            onComplete?(location)
        }
    }
    
    func debug(_ text: String){
        mapView.debug(text)
    }
    
}

extension MainViewController: LocationServiceDelegate{
    
    func authorizationDidChange(authorized: Bool, location: CLLocation?) {
        if authorized, let loc = location, state == .none{
            state = loc.horizontalAccuracy <= Preferences.instance.minHorizontalAccuracy ? .exact : .estimated
            mapView.stateDidChange(from: .none, to: state, location: loc)
        }
    }
    
    func locationDidChange(location: CLLocation) {
        switch state{
        case .none:
            state = location.horizontalAccuracy <= Preferences.instance.minHorizontalAccuracy ? .exact : .estimated
            mapView.stateDidChange(from: .none, to: state, location: location)
        case .estimated:
            if location.horizontalAccuracy <= Preferences.instance.minHorizontalAccuracy{
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
        let controller = LocationViewController()
        controller.location = location
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func deleteLocation(location: Location) {
        showApprove(title: "confirmDeleteLocation".localize(), text: "deleteLocationHint".localize()){
            Locations.instance.deleteLocation(location)
            Locations.instance.save()
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
    
    func addLocation(){
        let coordinate = mapView.getVisibleCenterCoordinate()
        assertLocation(coordinate: coordinate, askForNext: true){ location in
            
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
            Locations.instance.deleteAllLocations()
            self.mapView.locationLayerView.setupLocationMarkers()
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
            assertLocation(coordinate: location.coordinate){ location in
                let changeState = location.photos.isEmpty
                location.addPhoto(photo: photo)
                Locations.instance.save()
                if changeState{
                    DispatchQueue.main.async {
                        print("changeState")
                        self.mapView.locationLayerView.updateLocationState(location)
                    }
                }
            }
        }
    }
    
}

extension MainViewController: LocationEditDelegate{
    
    func updateLocationState(location: Location) {
        mapView.locationLayerView.updateLocationState(location)
    }
    
    func updateLocationLayer() {
        mapView.locationLayerView.setNeedsDisplay()
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
                if let location = track.trackpoints.first{
                    self.assertLocation(coordinate: location.coordinate){ location in
                        let changeState = location.tracks.isEmpty
                        location.addTrack(track: track)
                        Locations.instance.save()
                        Tracks.instance.saveTrackCurrentTrack()
                        if changeState{
                            DispatchQueue.main.async {
                                print("changeState")
                                self.mapView.locationLayerView.updateLocationState(location)
                            }
                        }
                    }
                }
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

extension MainViewController: LocationListDelegate{
    
    func showOnMap(location: Location) {
        mapView.scrollToCenteredCoordinate(coordinate: location.coordinate)
    }

}

