//
//  OSM-Maps
//
//  Created by Michael Rönnau on 30.10.21.
//

import UIKit

protocol PlaceMarkerViewDelegate{
    func showPlaceDetails(place: PlaceData)
    func editPlaceData(place: PlaceData)
    func deletePlaceData(place: PlaceData)
}

class PlaceMarkerView: UIView {
    
    var delegate : PlaceMarkerViewDelegate? = nil
    
    func setupPlaceMarkers(){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let places = PlaceCache.instance.placesInPlanetRect(MapStatics.planetRect)
        for place in places{
            addPlaceMarkerControl(place: place)
        }
    }
    
    func addPlaceMarkerControl(place: PlaceData){
        let control = PlaceMarkerControl(place: place)
        addSubview(control)
        control.delegate = self
        control.createMenu()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is PlaceMarkerControl && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        for sv in subviews{
            if let av = sv as? PlaceMarkerControl{
                av.updatePosition(to: CGPoint(x: (av.place.planetPosition.x - normalizedOffset.point.x)*scale , y: (av.place.planetPosition.y - normalizedOffset.point.y)*scale))
            }
        }
    }
    
}

extension PlaceMarkerView: PlaceMarkerControlDelegate{
    
    func detailAction(sender: PlaceMarkerControl) {
        delegate?.showPlaceDetails(place: sender.place)
    }
    
    func editAction(sender: PlaceMarkerControl) {
        delegate?.editPlaceData(place: sender.place)
    }
    
    func deleteAction(sender: PlaceMarkerControl) {
        subviews.first(where: {$0 == sender})?.removeFromSuperview()
        delegate?.deletePlaceData(place: sender.place)
    }
    
    
}

