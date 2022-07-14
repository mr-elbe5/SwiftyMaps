/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation
import AVKit



class MapViewController :  UIViewController {
    
    var mapView = MapView()
    
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
        LocationService.shared.delegate = mapView
    }
    
}

extension MapViewController: LocationLayerViewDelegate{
    
    func showLocationDetails(location: LocationData) {
        let controller = LocationDetailViewController()
        controller.location = location
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}

extension MapViewController: ControlLayerDelegate{
    
    func focusUserLocation() {
        mapView.focusUserLocation()
    }
    
    func updatePinVisibility() {
        mapView.updatePinVisibility()
    }
    
    func preloadMap() {
        let region = mapView.currentMapRegion
        let controller = MapPreloadViewController()
        controller.mapRegion = region
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func deleteTiles() {
        showDestructiveApprove(title: "confirmDeleteTiles".localize(), text: "deleteTilesHint".localize()){
            MapTiles.clear()
            self.mapView.clearTiles()
        }
    }
    
    func addLocation(){
        if let position = LocationService.shared.lastPosition{
            assertLocation(coordinate: position.coordinate){ location in
                self.updateLocationLayer()
            }
        }
    }
    
    func startTracking() {
        TrackPool.startTracking()
        mapView.trackLayerView.setTrack(track: TrackPool.activeTrack)
    }
    
    func updateTrackLayer() {
        mapView.updateTrackLayer()
    }
    
    func showsTrack() -> Bool {
        mapView.trackLayerView.track != nil
    }
    
    func hideTrack() {
        mapView.trackLayerView.setTrack(track: nil)
    }
    
    func saveAndCloseTracking(){
        if TrackPool.isTracking{
            let alertController = UIAlertController(title: "name".localize(), message: "nameOrDescriptionHint".localize(), preferredStyle: .alert)
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
                TrackPool.saveTrack(name: alertController.textFields![0].text ?? "Track")
                self.mapView.controlLayerView.trackingStopped()
            })
            present(alertController, animated: true)
        }
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

extension MapViewController: PhotoCaptureDelegate{
    
    func photoCaptured(photo: PhotoData) {
        if let lastPosition = LocationService.shared.lastPosition{
            assertLocation(coordinate: lastPosition.coordinate){ location in
                let changeState = location.photos.isEmpty
                location.addPhoto(photo: photo)
                LocationPool.save()
                if changeState{
                    DispatchQueue.main.async {
                        self.updateLocationLayer()
                    }
                }
            }
        }
    }
    
}

extension MapViewController: LocationViewDelegate{
    
    func updateLocationLayer() {
        mapView.updateLocationLayer()
    }
    
}

extension MapViewController: LocationsDelegate{
    
    func showOnMap(location: LocationData) {
        mapView.scrollToCenteredCoordinate(coordinate: location.coordinate)
    }
    
    func deleteLocation(location: LocationData) {
        LocationPool.deleteLocation(location)
        LocationPool.save()
        updateLocationLayer()
    }

}

extension MapViewController: TracksViewDelegate{
    
    func deleteTrack(track: TrackData, approved: Bool) {
        if approved{
            deleteTrack(track: track)
        }
        else{
            showDestructiveApprove(title: "confirmDeleteTrack".localize(), text: "deleteTrackHint".localize()){
                self.deleteTrack(track: track)
            }
        }
    }
    
    private func deleteTrack(track: TrackData){
        TrackPool.deleteTrack(track)
        mapView.clearTrack(track)
        updateLocationLayer()
    }
    
    func showTrackOnMap(track: TrackData) {
        mapView.trackLayerView.setTrack(track: track)
        if let startPoint = track.trackpoints.first{
            mapView.scrollToCenteredCoordinate(coordinate: startPoint.coordinate)
        }
    }
    
}


