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
    
    var lastDirection : Int = 0
    var running = false
    
    var delegates : Array<LocationServiceDelegate> = []
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var lastPositions : Array<Position> = []
    
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
    
    var lastPosition: Position?{
        return lastPositions.last
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = 2.0
        
    }
    
    func getPlacemarkInfo(for location: Location){
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
    
    func addPosition(loc: CLLocation) -> Bool{
        lastPositions.append(Position(location: loc))
        if lastPositions.count > 5{
            lastPositions.remove(at: 0)
        }
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
        let loc = locations.last!
        if loc.horizontalAccuracy == -1{
            return
        }
        if addPosition(loc: loc){
            for delegate in delegates{
                delegate.positionDidChange(position: lastPosition!)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastDirection = Int(newHeading.trueHeading.rounded())
        for delegate in delegates{
            delegate.directionDidChange(direction: lastDirection)
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        running = false
        if let pos = lastPosition{
            let monitoredRegion = CLCircularRegion(center: pos.coordinate, radius: 5.0, identifier: "monitoredRegion")
            locationManager.startMonitoring(for: monitoredRegion)
        }
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        running = true
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == "monitoredRegion"{
            locationManager.stopMonitoring(for: region)
            if authorized{
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
                running = true
            }
        }
    }
    
}



