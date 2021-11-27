//
//  OSM-Maps
//
//  Created by Michael Rönnau on 30.10.21.
//

import UIKit

protocol LocationLayerViewDelegate{
    func showLocationDetails(location: Location)
    func editLocation(location: Location)
    func deleteLocation(location: Location)
}

class LocationLayerView: UIView {
    
    var delegate : LocationLayerViewDelegate? = nil
    
    func setupLocationMarkers(){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let locations = Locations.instance.locationsInPlanetRect(MapStatics.planetRect)
        for location in locations{
            addLocationView(location: location)
        }
    }
    
    func addLocationView(location: Location){
        let locationView = LocationPinView(location: location)
        addSubview(locationView)
        locationView.delegate = self
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
    
}

extension LocationLayerView: LocationDelegate{
    
    func detailAction(sender: LocationPinView) {
        delegate?.showLocationDetails(location: sender.location)
    }
    
    func editAction(sender: LocationPinView) {
        delegate?.editLocation(location: sender.location)
    }
    
    func deleteAction(sender: LocationPinView) {
        subviews.first(where: {$0 == sender})?.removeFromSuperview()
        delegate?.deleteLocation(location: sender.location)
    }
    
    
}

