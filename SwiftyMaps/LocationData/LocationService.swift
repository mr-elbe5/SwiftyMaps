/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate{
    func authorizationDidChange(authorization: CLAuthorizationStatus)
    func positionDidChange(position: Position)
    func directionDidChange(direction: Int)
}

class LocationService : NSObject{
    
    static var shared = LocationService()
    
    var lastPosition : Position? = nil
    var lastDirection : Int = 0
    var running = false
    
    var delegates : Array<LocationServiceDelegate> = []
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
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
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = 2.0
        
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
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.showsBackgroundLocationIndicator = true
            locationManager.startUpdatingHeading()
            running = true
        }
    }
    
    func checkRunning(){
        if authorized && !running{
            start()
        }
    }
    
    func stop(){
        if running{
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            running = false
        }
    }
    
    func requestWhenInUseAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysAuthorization(){
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func setPosition(loc: CLLocation) -> Bool{
        if loc.horizontalAccuracy == -1{
            return false
        }
        lastPosition = Position(location: loc)
        return true
    }
    
}

extension LocationService : CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkRunning()
        for delegate in delegates{
            delegate.authorizationDidChange(authorization: manager.authorizationStatus)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            if setPosition(loc: loc), let position = lastPosition{
                for delegate in delegates{
                    delegate.positionDidChange(position: position)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastDirection = Int(newHeading.trueHeading.rounded())
        for delegate in delegates{
            delegate.directionDidChange(direction: lastDirection)
        }
    }
    
}



