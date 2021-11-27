/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate{
    func locationDidChange(location: CLLocation)
    func directionDidChange(direction: CLLocationDirection)
    func authorizationDidChange(authorized: Bool, location: CLLocation?)
}

enum LocationState: String{
    case none
    case estimated
    case exact
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
        //print("loc start: running = \(running)")
    }
    
    func checkRunning(){
        if authorized && !running{
            //print("run after check")
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //print("changed auth")
        checkRunning()
        delegate?.authorizationDidChange(authorized: authorized, location: lastLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            //print("loc \(loc.coordinate), horzAcc: \(loc.horizontalAccuracy), vertAcc: \(loc.verticalAccuracy), time: \(loc.timestamp.timeString())")
            if let lst = lastLocation{
                print("diff ->\(lst.coordinate.distance(to: loc.coordinate)) time: \(Int(lst.timestamp.distance(to: loc.timestamp)))")
            }
            if loc.horizontalAccuracy == -1{
                print("invalid position")
                return
            }
            lastLocation = loc
            delegate?.locationDidChange(location: loc)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastDirection = newHeading.trueHeading
        delegate?.directionDidChange(direction: lastDirection)
    }
    
}

