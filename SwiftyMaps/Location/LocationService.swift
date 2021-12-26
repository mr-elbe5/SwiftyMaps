/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate{
    func locationDidChange(location: CLLocation)
    func directionDidChange(direction: CLLocationDirection)
}

class LocationService : NSObject, CLLocationManagerDelegate{
    
    static var shared = LocationService()
    
    var lastLocation : CLLocation? = nil
    var lastDirection : CLLocationDirection = 0
    var running = false
    var delegate : LocationServiceDelegate? = nil
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var lock = DispatchSemaphore(value: 1)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.headingFilter = 2.0
        
    }
    
    var authorized : Bool{
        get{
            return locationManager.authorized
        }
    }
    
    var authorizedForTracking : Bool{
        get{
            return locationManager.authorizedForTracking
        }
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
        if authorized{
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            running = true
        }
        Log.log("loc start: running = \(running)")
    }
    
    func checkRunning(){
        if authorized && !running{
            Log.log("run after check")
            start()
        }
    }
    
    func stop(){
        if running{
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
        }
    }
    
    func requestWhenInUseAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysAuthorization(){
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Log.log("changed auth")
        checkRunning()
        if authorized, let loc = lastLocation{
            delegate?.locationDidChange(location: loc)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last!
        if loc.horizontalAccuracy == -1{
            Log.log("invalid position")
            return
        }
        Log.log("location changed to \(loc.toString())")
        lastLocation = loc
        delegate?.locationDidChange(location: loc)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastDirection = newHeading.trueHeading
        delegate?.directionDidChange(direction: lastDirection)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        Log.log("location updates paused")
        running = false
        if let loc = lastLocation{
            let monitoredRegion = CLCircularRegion(center: loc.coordinate, radius: 5.0, identifier: "monitoredRegion")
            locationManager.startMonitoring(for: monitoredRegion)
        }
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        Log.log("location updates resumed")
        running = true
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        Log.log("location exited region")
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

