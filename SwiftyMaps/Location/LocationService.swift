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
    func authorizationDidChange(authorized: Bool)
}

class LocationService : NSObject, CLLocationManagerDelegate{
    
    static var shared = LocationService()
    
    static var locationDeviation : CLLocationDistance = 5.0
    static var headingDeviation : CLLocationDirection = 2.0
    
    var location : CLLocation? = nil
    var direction : CLLocationDirection = 0
    var placemark : CLPlacemark? = nil
    var running = false
    var delegate : LocationServiceDelegate? = nil
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var lock = DispatchSemaphore(value: 1)
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var authorized : Bool{
        get{
            return locationManager.authorized
        }
    }
    
    func getLocationDescription(placemark: CLPlacemark) -> String {
        var s = ""
        if let name = placemark.name{
            s += name
        }
        if let locality = placemark.locality{
            if !s.isEmpty{
                s += ", "
            }
            s += locality
        }
        return s
    }
    
    func getLocationDescription() -> String {
        if let place = placemark{
            return getLocationDescription(placemark: place)
        }
        return ""
    }
    
    func getLocationDescription(coordinate: CLLocationCoordinate2D, completion: @escaping(String) -> ()){
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        getLocationDescription(location: location, completion: completion)
    }
    
    func getLocationDescription(location: CLLocation, completion: @escaping(String) -> ()){
        var description = ""
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil, let placemark =  placemarks?[0]{
                description = self.getLocationDescription(placemark: placemark)
                completion(description)
            }
            else{
                completion("")
            }
        })
    }
    
    func lookUpCurrentLocation() {
        if let lastLocation = location {
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    self.placemark = placemarks?[0]
                }
            })
        }
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
        delegate?.authorizationDidChange(authorized: authorized)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if location == nil || newLocation.distance(from: location!) > LocationService.locationDeviation {
            location = newLocation
            lookUpCurrentLocation()
            delegate?.locationDidChange(location: location!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if abs(newHeading.trueHeading - direction) > LocationService.headingDeviation{
            direction = newHeading.trueHeading
            delegate?.directionDidChange(direction: direction)
        }
        
    }
    
}

