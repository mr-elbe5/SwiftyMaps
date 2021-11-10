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
        mapView.setupPlacesView()
        mapView.placesView.delegate = self
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

extension MainViewController: PlacesViewDelegate{
    
    func showPlaceDetails(place: PlaceData) {
        let controller = PlaceDetailViewController()
        controller.place = place
        present(controller, animated: true)
    }
    
    func editPlaceData(place: PlaceData) {
        let controller = PlaceEditViewController()
        controller.place = place
        
        present(controller, animated: true)
    }
    
    func deletePlace(place: PlaceData) {
        PlaceCache.instance.removePlace(place)
        PlaceCache.instance.save()
    }
    
}

extension MainViewController: MapControlDelegate{
    
    func focusUserLocation() {
        mapView.focusUserLocation()
    }
    
    func addPlaceAtCross(){
        let place = PlaceCache.instance.addPlace(coordinate: mapView.getVisibleCenterCoordinate())
        mapView.addPlace(place: place)
    }
    
    func addPlaceAtUserPosition(){
        if let location = LocationService.shared.location{
            let place = PlaceData(coordinate: location.coordinate)
            mapView.addPlace(place: place)
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
                    let data = PlaceImage()
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
    
    func removePlaces() {
        PlaceCache.instance.places.removeAll()
        mapView.placesView.setupPlaceMarkers()
    }
    
}

extension MainViewController: PhotoCaptureDelegate{
    
    func photoCaptured(photo: PlaceImage) {
        print("photo captured")
        //todo
    }
    
}
