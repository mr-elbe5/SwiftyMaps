/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol LocationLayerViewDelegate{
    func showLocationDetails(location: Location)
    func showLocationGroupDetails(locationGroup: LocationGroup)
}

class LocationLayerView: UIView {
    
    var delegate : LocationLayerViewDelegate? = nil
    
    func setupLocationMarkers(zoom: Int){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        if zoom == MapStatics.maxZoom{
            for location in Locations.list{
                addLocationPin(location: location)
            }
        }
        else{
            let planetDist = MapStatics.zoomScaleToPlanet(from: zoom) * Preferences.instance.pinGroupRadius
            var groups = Array<LocationGroup>()
            for location in Locations.list{
                var grouped = false
                for group in groups{
                    if group.isWithinRadius(location: location, radius: planetDist){
                        group.addLocation(location: location)
                        grouped = true
                    }
                }
                if grouped{
                    let group = LocationGroup()
                    group.addLocation(location: location)
                    groups.append(group)
                }
                
                
            }
            for group in groups{
                if group.locations.count > 1{
                    group.setCenter()
                    addLocationGroupPin(locationGroup: group)
                }
                else if let location = group.locations.first{
                    addLocationPin(location:location )
                }
            }
            
        }
    }
    
    func addLocationPin(location: Location){
        let pin = LocationPin(location: location)
        addSubview(pin)
        pin.addTarget(self, action: #selector(showLocationDetails), for: .touchDown)
    }
    
    func addLocationGroupPin(locationGroup: LocationGroup){
        let pin = LocationGroupPin(locationGroup: locationGroup)
        addSubview(pin)
        pin.addTarget(self, action: #selector(showLocationGroupDetails), for: .touchDown)
    }
    
    func removePin(location: Location){
        subviews.first(where: {
            if let pin = $0 as? LocationPin{
                return pin.location == location
            }
            if let pin = $0 as? LocationGroupPin{
                return pin.locationGroup.hasLocation(location: location)
            }
            return false
        })?.removeFromSuperview()
    }
    
    func getPin(location: Location) -> Pin?{
        for subview in subviews{
            if let pin = subview as? LocationPin, pin.location == location{
                return pin
            }
            if let pin = subview as? LocationGroupPin, pin.locationGroup.hasLocation(location: location){
                return pin
            }
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is Pin && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        for sv in subviews{
            if let av = sv as? LocationPin{
                av.updatePosition(to: CGPoint(x: (av.location.planetPosition.x - normalizedOffset.point.x)*scale , y: (av.location.planetPosition.y - normalizedOffset.point.y)*scale))
            }
        }
    }
    
    func updateLocationState(_ location: Location){
        if let pin = getPin(location: location){
            pin.updateColor()
        }
    }
    
    func zoomHasChanged(zoom: Int){
        //todo
    }
    
    @objc func showLocationDetails(_ sender: AnyObject){
        if let pin = sender as? LocationPin{
            delegate?.showLocationDetails(location: pin.location)
        }
    }
    
    @objc func showLocationGroupDetails(_ sender: AnyObject){
        if let pin = sender as? LocationGroupPin{
            delegate?.showLocationGroupDetails(locationGroup: pin.locationGroup)
        }
    }
    
}



