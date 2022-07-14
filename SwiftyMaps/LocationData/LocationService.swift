/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate{
    func authorizationDidChange(authorization: CLAuthorizationStatus, position: Position)
    func positionDidChange(position: Position)
    func headingDidChange(heading: Int)
}

class LocationService : NSObject{
    
    static var shared = LocationService()
    
    static let minHorizontalAccuracy = 20.0
    static let minDistanceChange = 1.0
    static let minHeadingChange = 2.0
    
    var lastPosition : Position? = nil
    var lastHeading : Int = 0
    var running = false
    
    var delegate : LocationServiceDelegate? = nil
    
    private let locationQueue = DispatchQueue(label: "swiftymaps.locationQueue")
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var positionQueue = Array<Position>()
    private var lock = DispatchSemaphore(value: 1)
    
    var authorization: CLAuthorizationStatus{
        locationManager.authorizationStatus
    }
    
    var authorized: Bool{
        let status = authorization
        return status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways
    }
    
    var authorizedAlways: Bool{
        return authorization == CLAuthorizationStatus.authorizedAlways
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = LocationService.minDistanceChange
        locationManager.headingFilter = LocationService.minHeadingChange
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        
    }
    
    func getPlacemarkInfo(for location: LocationData){
        geocoder.reverseGeocodeLocation(location.cllocation, completionHandler: { (placemarks, error) in
            if error == nil, let placemark =  placemarks?[0]{
                location.addPlacemarkInfo(placemark: placemark)
            }
        })
    }
    
    func start(){
        lock.wait()
        defer{lock.signal()}
        if authorized, !running{
            locationQueue.async{
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
                self.running = true
            }
        }
    }
    
    func checkRunning(){
        if authorized && !running{
            start()
        }
    }
    
    func stop(){
        if running{
            locationQueue.async{
                self.locationManager.stopUpdatingLocation()
                self.locationManager.stopUpdatingHeading()
                self.running = false
            }
        }
    }
    
    func requestWhenInUseAuthorization(){
        locationQueue.async{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestAlwaysAuthorization(){
        locationQueue.async{
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func setPosition(loc: CLLocation) -> Bool{
        if loc.horizontalAccuracy == -1 || loc.horizontalAccuracy > LocationService.minHorizontalAccuracy{
            print("low accuracy")
            return false
        }
        let position = Position(location: loc)
        if let previousPosition = positionQueue.last{
            position.calculateLastSpeedAndBearing(previousPosition: previousPosition)
        }
        positionQueue.append(position)
        if positionQueue.count > 5{
            positionQueue.remove(at: 0)
        }
        lastPosition = positionQueue.last
        return true
    }
    
}

extension LocationService : CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkRunning()
        if let position = self.lastPosition{
            DispatchQueue.main.async {
                self.delegate?.authorizationDidChange(authorization: manager.authorizationStatus, position: position)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            if setPosition(loc: loc), let position = lastPosition{
                DispatchQueue.main.async {
                    self.delegate?.positionDidChange(position: position)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastHeading = Int(newHeading.trueHeading.rounded())
        DispatchQueue.main.async {
            self.delegate?.headingDidChange(heading: self.lastHeading)
        }
    }
    
}



