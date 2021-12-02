/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol LocationLayerViewDelegate{
    func showLocationDetails(location: Location)
}

class LocationLayerView: UIView {
    
    var delegate : LocationLayerViewDelegate? = nil
    
    func setupLocationMarkers(){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let locations = Locations.locationsInPlanetRect(MapStatics.planetRect)
        for location in locations{
            addLocationView(location: location)
        }
    }
    
    func addLocationView(location: Location){
        let locationView = LocationPinView(location: location)
        addSubview(locationView)
        locationView.addTarget(self, action: #selector(showLocationDetails), for: .touchDown)
    }
    
    func removeLocationView(location: Location){
        subviews.first(where: {
            if let pin = $0 as? LocationPinView{
                return pin.location == location
            }
            return false
        })?.removeFromSuperview()
    }
    
    func getLocationPin(location: Location) -> LocationPinView?{
        for subview in subviews{
            if let pin = subview as? LocationPinView, pin.location == location{
                return pin
            }
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is LocationPinView && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        for sv in subviews{
            if let av = sv as? LocationPinView{
                av.updatePosition(to: CGPoint(x: (av.location.planetPosition.x - normalizedOffset.point.x)*scale , y: (av.location.planetPosition.y - normalizedOffset.point.y)*scale))
            }
        }
    }
    
    func updateLocationState(_ location: Location){
        if let pin = getLocationPin(location: location){
            pin.updateImage()
        }
    }
    
    func scaleHasChanged(scale: CGFloat){
        isHidden = (scale < MapStatics.zoomScaleFromPlanet(to: Preferences.instance.minZoomToShowLocations))
    }
    
    @objc func showLocationDetails(_ sender: AnyObject){
        if let pin = sender as? LocationPinView{
            delegate?.showLocationDetails(location: pin.location)
        }
    }
    
}

